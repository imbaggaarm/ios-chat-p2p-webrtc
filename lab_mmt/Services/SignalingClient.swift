//
//  SignalingClient.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/27/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation
import WebRTC

protocol SignalClientDelegate: class {
    func signalClientDidConnect(_ signalClient: SignalingClient)
    func signalClientDidDisconnect(_ signalClient: SignalingClient)
    func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription, fromUser userID: UserID)
    func signalClient(_ signalClient: SignalingClient, didReceiveAnswerSdp sdp: RTCSessionDescription, fromUser userID: UserID)
    func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate, fromUser userID: UserID)
    func signalClient(_ signalClient: SignalingClient, didReceiveOnlineState onlineState: WSOnlineState, fromUser userID: UserID)
    func signalClient(_ signalClient: SignalingClient, didReceiveFailedOfferFromUser userID: UserID)
}

final class SignalingClient {
    
    public static var shared: SignalingClient!
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let webSocket: WebSocketProvider
    weak var delegate: SignalClientDelegate?
    
    init() {
        // iOS 13 has native websocket support. For iOS 12 or lower we will use 3rd party library.
        let url = URL.init(string: Config.default.signalingServerUrlStr + "?token=\(UserProfile.this.token)")!
        if #available(iOS 13.0, *) {
            self.webSocket = NativeWebSocket(url: url)
        } else {
            self.webSocket = StarscreamWebSocket(url: url)
        }
        SignalingClient.shared = self
    }
        
    func connect() {
        self.webSocket.delegate = self
        self.webSocket.connect()
    }
    
    func disconnect() {
        self.webSocket.delegate = nil
        self.webSocket.disconnect()
    }
    
    func sendOnlineStateChange(username: String, state: WSOnlineState) {
        print("sending online state")
        let message = WSMessage.onlineState(OnlineStateData.init(username: username, onlineState: state))
        do {
            let dataMessage = try self.encoder.encode(message)
            self.webSocket.send(data: dataMessage)
        }
        catch {
            debugPrint("Warning: Could not encode sdp: \(error)")
        }
    }
        
    func sendOffer(username: UserID, partnerUsername: UserID, sdp rtcSdp: RTCSessionDescription) {
        
        print("send offer to: ", partnerUsername)
        
        let message = WSMessage.offer(OfferData(sdp: SessionDescription(from: rtcSdp), fromID: username, toID: partnerUsername))
        do {
            let dataMessage = try self.encoder.encode(message)
            
            self.webSocket.send(data: dataMessage)
        }
        catch {
            debugPrint("Warning: Could not encode sdp: \(error)")
        }
        
    }
    
    func sendAnswer(username: UserID, toUser userID: UserID, sdp rtcSdp: RTCSessionDescription) {
        print("send answer to: ", userID)
        let message = WSMessage.answer(AnswerData(sdp: SessionDescription(from: rtcSdp), fromID: username, toID: userID))
        do {
            let dataMessage = try self.encoder.encode(message)
            self.webSocket.send(data: dataMessage)
        }
        catch {
            debugPrint("Warning: Could not encode sdp: \(error)")
        }

    }
            
    func send(candidate rtcIceCandidate: RTCIceCandidate, toUser userID: UserID) {
        let message = WSMessage.candidate(CandidateData(candidate: IceCandidate(from: rtcIceCandidate), fromID: UserProfile.this.username, toID: userID))
        do {
            let dataMessage = try self.encoder.encode(message)
            
            self.webSocket.send(data: dataMessage)
        }
        catch {
            debugPrint("Warning: Could not encode candidate: \(error)")
        }
    }
}


extension SignalingClient: WebSocketProviderDelegate {
    func webSocketDidConnect(_ webSocket: WebSocketProvider) {
        self.delegate?.signalClientDidConnect(self)
    }
    
    func webSocketDidDisconnect(_ webSocket: WebSocketProvider) {
        self.delegate?.signalClientDidDisconnect(self)
        
        // try to reconnect every two seconds
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            debugPrint("Trying to reconnect to signaling server...")
            self.webSocket.connect()
        }
    }
    
    func webSocket(_ webSocket: WebSocketProvider, didReceiveString string: String) {
        let message: WSMessage
        do {
            let data = Data(string.utf8)
            message = try self.decoder.decode(WSMessage.self, from: data)
            print("Succeeded")
        }
        catch {
            debugPrint("Warning: Could not decode incoming message: \(error)")
            return
        }
        
//        print(message)
        switch message {
        case .offer(let offerData):
            self.delegate?.signalClient(self, didReceiveRemoteSdp: offerData.sdp.rtcSessionDescription, fromUser: offerData.fromID)
        case .offerRespone(_):
            break
        case .answer(let answerData):
            //print(answerData)
            self.delegate?.signalClient(self, didReceiveAnswerSdp: answerData.sdp.rtcSessionDescription, fromUser: answerData.fromID)
        case .candidate(let candidateData):
            self.delegate?.signalClient(self, didReceiveCandidate: candidateData.candidate.rtcIceCandidate, fromUser: candidateData.fromID)
        case .onlineState(let onlineStateData):
            self.delegate?.signalClient(self, didReceiveOnlineState: onlineStateData.onlineState, fromUser: onlineStateData.username)
        }
    }
    
    func webSocket(_ webSocket: WebSocketProvider, didReceiveData data: Data) {
        let message: WSMessage
        do {
            message = try self.decoder.decode(WSMessage.self, from: data)
        }
        catch {
            debugPrint("Warning: Could not decode incoming message: \(error)")
            return
        }
        
        print(message)
        
//        switch message {
//        case .candidate(let iceCandidate):
//            self.delegate?.signalClient(self, didReceiveCandidate: iceCandidate.rtcIceCandidate)
//        case .sdp(let sessionDescription):
//            self.delegate?.signalClient(self, didReceiveRemoteSdp: sessionDescription.rtcSessionDescription)
//        }

    }
}

