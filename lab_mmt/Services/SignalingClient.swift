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
    func signalClient(_ signalClient: SignalingClient, didReceiveFailedOfferFromUser userID: UserID)
}

final class SignalingClient {
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let webSocket: WebSocketProvider
    weak var delegate: SignalClientDelegate?
    
    init(webSocket: WebSocketProvider) {
        self.webSocket = webSocket
    }
    
    func connect() {
        self.webSocket.delegate = self
        self.webSocket.connect()
        
    }
    
//    func sendMessage(message: [String: Any]) {
//        do {
//            let dataMessage = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
//            
////            let decoded = try JSONSerialization.jsonObject(with: dataMessage, options: [])
////            print(decoded)
//
//            webSocket.send(data: dataMessage)
//        }
//        catch {
//            debugPrint("Warning: Could not encode message: \(error)")
//        }
//    }
    
    func send(username: String) {
        let loginData = LoginData(username: username)
        let message = MyMessage.login(loginData)

        do {
            let dataMessage = try self.encoder.encode(message)
            self.webSocket.send(data: dataMessage)
        }
        catch {
            debugPrint("Warning: Could not encode message: \(error)")
        }
    }
    
    func sendOffer(username: UserID, partnerUsername: UserID, sdp rtcSdp: RTCSessionDescription) {
        
        print("send offer to: ", partnerUsername)
        
        let message = MyMessage.offer(OfferData(sdp: SessionDescription(from: rtcSdp), fromID: username, toID: partnerUsername))
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
        let message = MyMessage.answer(AnswerData(sdp: SessionDescription(from: rtcSdp), fromID: username, toID: userID))
        do {
            let dataMessage = try self.encoder.encode(message)
            self.webSocket.send(data: dataMessage)
        }
        catch {
            debugPrint("Warning: Could not encode sdp: \(error)")
        }

    }
            
    func send(candidate rtcIceCandidate: RTCIceCandidate, toUser userID: UserID) {
        let message = MyMessage.candidate(CandidateData(candidate: IceCandidate(from: rtcIceCandidate), fromID: User.this.username, toID: userID))
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
//        print(string)
        
        let message: MyMessage
        do {
            let data = Data(string.utf8)
            message = try self.decoder.decode(MyMessage.self, from: data)
            print("Succeeded")
        }
        catch {
//            debugPrint("Warning: Could not decode incoming message: \(error)")
            return
        }
        
//        print(message)
        switch message {
        case .offer(let offerData):
            self.delegate?.signalClient(self, didReceiveRemoteSdp: offerData.sdp.rtcSessionDescription, fromUser: offerData.fromID)
        case .offerRespone(let response):
//            print(response.fromID)
//            print(response.success)
            if !response.success {
                //self.delegate?.signalClient(self, didReceiveFailedOfferFromUser: response.fromID)
            }
        case .answer(let answerData):
            //print(answerData)
            self.delegate?.signalClient(self, didReceiveAnswerSdp: answerData.sdp.rtcSessionDescription, fromUser: answerData.fromID)
        case .candidate(let candidateData):
            self.delegate?.signalClient(self, didReceiveCandidate: candidateData.candidate.rtcIceCandidate, fromUser: candidateData.fromID)
        default:
            break
        }
    }
    
    func webSocket(_ webSocket: WebSocketProvider, didReceiveData data: Data) {
        let message: MyMessage
        do {
            message = try self.decoder.decode(MyMessage.self, from: data)
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

