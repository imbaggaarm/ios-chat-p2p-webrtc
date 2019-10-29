//
//  WebRTCClient.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/27/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation
import WebRTC

typealias UserID = String

protocol MyWebRTCClientDelegate: class {
    func webRTCClient(_ client: MyWebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate, forUser userID: UserID)
    func webRTCClient(_ client: MyWebRTCClient, didChangeConnectionState state: RTCIceConnectionState)
    func webRTCClient(_ client: MyWebRTCClient, didReceiveData data: Data)
}


final class MyWebRTCClient: NSObject {
    private static let factory: RTCPeerConnectionFactory = {
        RTCInitializeSSL()
        let videoEncoderFactory = RTCDefaultVideoEncoderFactory()
        let videoDecoderFactory = RTCDefaultVideoDecoderFactory()
        return RTCPeerConnectionFactory(encoderFactory: videoEncoderFactory, decoderFactory: videoDecoderFactory)
    }()
    
    var peerConnections = [String: RTCPeerConnection]()
    var localDataChannels = [String: RTCDataChannel]()
    var remoteDataChannels = [String: RTCDataChannel]()
    var iceServers: [String]
    
    private let mediaConstrains = [kRTCMediaConstraintsOfferToReceiveAudio: kRTCMediaConstraintsValueTrue,
                                   kRTCMediaConstraintsOfferToReceiveVideo: kRTCMediaConstraintsValueTrue]
    
    weak var delegate: MyWebRTCClientDelegate?
    
    
    @available(*, unavailable)
    override init() {
        fatalError("WebRTCClient:init is unavailable")
    }
    
    required init(iceServers: [String]) {
        self.iceServers = iceServers
        super.init()
    }
    
    private func createMediaSenders(forUser userID: UserID) {
        //        let streamId = "stream"
        
        //        // Audio
        //        let audioTrack = self.createAudioTrack()
        //        self.peerConnection.add(audioTrack, streamIds: [streamId])
        //
        //        // Video
        //        let videoTrack = self.createVideoTrack()
        //        self.localVideoTrack = videoTrack
        //        self.peerConnection.add(videoTrack, streamIds: [streamId])
        //        self.remoteVideoTrack = self.peerConnection.transceivers.first { $0.mediaType == .video }?.receiver.track as? RTCVideoTrack
        
        // Data
        
    }
    
    //self.peerConnection = WebRTCClient.factory.peerConnection(with: config, constraints: constraints, delegate: nil)
    
    func createPeerConnection(for userID: UserID) -> RTCPeerConnection {
        
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil,
                                              optionalConstraints: ["DtlsSrtpKeyAgreement": kRTCMediaConstraintsValueTrue])
        
        let config = RTCConfiguration()
        config.iceServers = [RTCIceServer(urlStrings: iceServers)]
        
        // Unified plan is more superior than planB
        config.sdpSemantics = .unifiedPlan
        
        // gatherContinually will let WebRTC to listen to any network changes and send any new candidates to the other client
        config.continualGatheringPolicy = .gatherContinually
        let peerConnection = MyWebRTCClient.factory.peerConnection(with: config, constraints: constraints, delegate: self)
        
        // add to peer connection dict
        self.peerConnections[userID] = peerConnection
        
        // create data channel
        createDataChannel(forUser: userID)
        return peerConnection
    }
    
    // MARK: Signaling
    func offer(peerConnection: RTCPeerConnection, completion: @escaping (_ sdp: RTCSessionDescription) -> Void) {
        
        let constraints = RTCMediaConstraints(mandatoryConstraints: self.mediaConstrains,
                                              optionalConstraints: nil)
        
        
        peerConnection.offer(for: constraints) { (sdp, error) in
            guard let sdp = sdp else {
                return
            }
            
            peerConnection.setLocalDescription(sdp, completionHandler: { (error) in
                completion(sdp)
            })
        }
    }
    
    func answer(peerConnection: RTCPeerConnection, completion: @escaping (_ sdp: RTCSessionDescription) -> Void)  {
        let constrains = RTCMediaConstraints(mandatoryConstraints: self.mediaConstrains,
                                             optionalConstraints: nil)
        peerConnection.answer(for: constrains) { (sdp, error) in
            guard let sdp = sdp else {
                print(error!.localizedDescription)
                return
            }
            
            peerConnection.setLocalDescription(sdp, completionHandler: { (error) in
                completion(sdp)
            })
        }
    }
    
    func answer(forUserID userID: UserID, completion: @escaping (_ sdp: RTCSessionDescription) -> Void) {
        guard let peerConnection = self.peerConnections[userID] else {
            print("COULD NOT FIND PEER WITH ID: ", userID)
            return
        }
        
        answer(peerConnection: peerConnection, completion: completion)
    }
    
    func set(remoteSdp: RTCSessionDescription, for userID: UserID, completion: @escaping (Error?) -> ()) {
        if let peerConnection = self.peerConnections[userID] {
            //
            peerConnection.close()
        }
        
        let peerConnection = createPeerConnection(for: userID)
        
        print("willset: ", peerConnection.signalingState)
        peerConnection.setRemoteDescription(remoteSdp) { (err) in
            print("didset: ", peerConnection.signalingState)
            completion(err)
        }
        
    }
    
    func set(answerRemoteSdp remoteSdp: RTCSessionDescription, for userID: UserID, completion: @escaping (Error?) -> ()) {
        guard let peerConnection = self.peerConnections[userID] else {
            print("COULD NOT FIND PEER WITH ID: ", userID)
            return
        }
        
        print("ans willset: ", peerConnection.signalingState)
        peerConnection.setRemoteDescription(remoteSdp) { (err) in
            print("ans didset: ", peerConnection.signalingState)
            completion(err)
        }
    }
    
    func set(remoteCandidate: RTCIceCandidate, for userID: UserID) {
        guard let peerConnection = self.peerConnections[userID] else {
            print("COULD NOT FIND PEER WITH ID: ", userID)
            return
        }
        
        peerConnection.add(remoteCandidate)
    }
    
    func removePeerConnection(forUser userID: UserID) {
        guard let peerConnection = self.peerConnections[userID] else {
            print("COULD NOT FIND PEER WITH ID: ", userID)
            return
        }
        
        print(self.peerConnections)
        peerConnection.close()
        self.peerConnections.removeValue(forKey: userID)
        print(self.peerConnections)
    }
    
    // MARK: Data Channels
    private func createDataChannel(forUser userID: UserID) {
        let config = RTCDataChannelConfiguration()
        config.isOrdered = true
        
        guard let peerConnection = peerConnections[userID], let dataChannel = peerConnection.dataChannel(forLabel: "channel1", configuration: config) else {
            debugPrint("Warning: Couldn't create data channel.")
            return
        }
        
        dataChannel.delegate = self
        localDataChannels[userID] = dataChannel
    }
    
    func sendData(toUserID: UserID, _ data: Data) {
        guard let userDataChannel = remoteDataChannels[toUserID] else {
            print("CAN NOT FIND TO USER")
            return
        }
        
        let buffer = RTCDataBuffer(data: data, isBinary: true)
        userDataChannel.sendData(buffer)
    }
}

extension MyWebRTCClient: RTCDataChannelDelegate {
    func dataChannelDidChangeState(_ dataChannel: RTCDataChannel) {
        debugPrint("dataChannel did change state: \(dataChannel.readyState)")
//        switch dataChannel.readyState {
//        case .open:
//            print("opened")
//        case .closed:
//            print("closed")
//        default:
//            break
//        }
    }
    
    func dataChannel(_ dataChannel: RTCDataChannel, didReceiveMessageWith buffer: RTCDataBuffer) {
        self.delegate?.webRTCClient(self, didReceiveData: buffer.data)
    }
}

extension MyWebRTCClient: RTCPeerConnectionDelegate {
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        debugPrint("peerConnection new signaling state: \(stateChanged)")
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        debugPrint("peerConnection did add stream")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        debugPrint("peerConnection did remote stream")
    }
    
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        debugPrint("peerConnection should negotiate")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        debugPrint("peerConnection new connection state: \(newState)")
        switch newState {
        case .connected:
            for (uID, peer) in self.peerConnections {
                if peer.isEqual(peerConnection) {
                    for friend in friends {
                        if friend.username == uID {
                            friend.state = .online
                            self.delegate?.webRTCClient(self, didChangeConnectionState: newState)
                            break
                        }
                    }
                    break
                }
            }
        case .disconnected:
            for (uID, peer) in self.peerConnections {
                if peer.isEqual(peerConnection) {
                    for friend in friends {
                        if friend.username == uID {
                            friend.state = .offline
                            self.delegate?.webRTCClient(self, didChangeConnectionState: newState)
                            break
                        }
                    }
                    break
                }
            }
        default:
            break
        }
        
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        debugPrint("peerConnection new gathering state: \(newState)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        for (userID, peer) in self.peerConnections {
            if peer.isEqual(peerConnection) {
                self.delegate?.webRTCClient(self, didDiscoverLocalCandidate: candidate, forUser: userID)
                return
            }
        }
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        debugPrint("peerConnection did remove candidate(s)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        debugPrint("peerConnection did open data channel")
        
        dataChannel.delegate = self
        
//        let message = "Hello, tao la Tai ne"
//        let buffer = RTCDataBuffer(data: message.data(using: .utf8)!, isBinary: true)
//        dataChannel.sendData(buffer)
//        print(dataChannel.label)
        for (userID, peer) in self.peerConnections {
            if peer.isEqual(peerConnection) {
                remoteDataChannels[userID] = dataChannel
                return
            }
        }
    }
}
