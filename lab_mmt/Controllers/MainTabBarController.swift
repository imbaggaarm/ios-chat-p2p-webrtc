//
//  MainTabBarController.swift
//  unichat
//
//  Created by Imbaggaarm on 10/13/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit
import WebRTC

class MainTabBarController: UITabBarController {
    
    let signalClient: SignalingClient
    let webRTCClient: MyWebRTCClient
    let decoder = JSONDecoder()
    
    private var signalingConnected: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.signalingConnected {
                    //                    self.signalingStatusLabel?.text = "Connected"
                    //                    self.signalingStatusLabel?.textColor = UIColor.green
                }
                else {
                    //                    self.signalingStatusLabel?.text = "Not connected"
                    //                    self.signalingStatusLabel?.textColor = UIColor.red
                }
            }
        }
    }
    
    private var hasLocalSdp: Bool = false {
        didSet {
            DispatchQueue.main.async {
                //                self.localSdpStatusLabel?.text = self.hasLocalSdp ? "✅" : "❌"
            }
        }
    }
    
    private var localCandidateCount: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                //                self.localCandidatesLabel?.text = "\(self.localCandidateCount)"
            }
        }
    }
    
    private var hasRemoteSdp: Bool = false {
        didSet {
            DispatchQueue.main.async {
                //                self.remoteSdpStatusLabel?.text = self.hasRemoteSdp ? "✅" : "❌"
            }
        }
    }
    
    private var remoteCandidateCount: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                //                self.remoteCandidatesLabel?.text = "\(self.remoteCandidateCount)"
            }
        }
    }
    
    
    init(signalClient: SignalingClient, webRTCClient: MyWebRTCClient) {
        self.signalClient = signalClient
        self.webRTCClient = webRTCClient
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webRTCClient.delegate = self
        self.signalClient.delegate = self
        
        self.signalClient.connect()
        
        
        view.backgroundColor = .black
        tabBar.tintColor = AppColor.tintColor
        
        let chatListNVC = UINavigationController.init(rootViewController: ChatListVC())
        chatListNVC.view.backgroundColor = .black
        chatListNVC.tabBarItem.image = AppIcon.tabbarChat
        
        //        let roomExplorerNVC = UINavigationController.init(rootViewController: ExplorerViewController())
        //        roomExplorerNVC.tabBarItem.image = AppIcon.tabbarExplorer
        
        let friendsViewController = UINavigationController.init(rootViewController: FriendsViewController())
        friendsViewController.tabBarItem.image = AppIcon.tabbarFriends
        
        viewControllers = [chatListNVC, friendsViewController]
        
        selectedIndex = 0
        
        for vc in viewControllers! {
            vc.tabBarItem.title = nil
            vc.tabBarItem.imageInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: -6, right: 0)
        }
        
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
}

extension MainTabBarController: SignalClientDelegate {
    
    func signalClientDidConnect(_ signalClient: SignalingClient) {
        self.signalingConnected = true
        
        self.signalClient.send(username: UserProfile.this.username)
        
        for friend in myFriends {
            let peerConnection = self.webRTCClient.createPeerConnection(for: friend.username)
            
            self.webRTCClient.offer(peerConnection: peerConnection) { (sdp) in
                self.signalClient.sendOffer(username: UserProfile.this.username, partnerUsername: friend.username, sdp: sdp)
            }
        }
    }
    
    func signalClientDidDisconnect(_ signalClient: SignalingClient) {
        self.signalingConnected = false
    }
    
    
    func signalClient(_ signalClient: SignalingClient, didReceiveAnswerSdp sdp: RTCSessionDescription, fromUser userID: UserID) {
        print("Received answer sdp")
        self.webRTCClient.set(answerRemoteSdp: sdp, for: userID) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription, fromUser userID: UserID) {
        print("Received remote sdp")
        //        print(sdp)
        self.webRTCClient.set(remoteSdp: sdp, for: userID) { (error) in
            //self.hasRemoteSdp = true
            self.webRTCClient.answer(forUserID: userID) { (sdp) in
                self.signalClient.sendAnswer(username: UserProfile.this.username, toUser: userID, sdp: sdp)
            }
            
            //answer
        }
    }
    
    
    
    func signalClient(_ signalClient: SignalingClient, didReceiveFailedOfferFromUser userID: UserID) {
        print("Received failed offer")
        self.webRTCClient.removePeerConnection(forUser: userID)
    }
    
    func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate, fromUser userID: UserID) {
        print("Received remote candidate")
        self.remoteCandidateCount += 1
        self.webRTCClient.set(remoteCandidate: candidate, for: userID)
    }
}

extension MainTabBarController: MyWebRTCClientDelegate {
    func webRTCClient(_ client: MyWebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate, forUser userID: UserID) {
        print("discovered local candidate")
        self.localCandidateCount += 1
        self.signalClient.send(candidate: candidate, toUser: userID)
        //        print(candidate)
    }
    
    func webRTCClient(_ client: MyWebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
        let textColor: UIColor
//        switch state {
//        case .connected, .completed:
//            textColor = .green
//        case .disconnected:
//            textColor = .orange
//        case .failed, .closed:
//            textColor = .red
//        case .new, .checking, .count:
//            textColor = .black
//        @unknown default:
//            textColor = .black
//        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: MessageHandler.onPeerConnectionChanging, object: nil, userInfo: nil)
        }
    }
    
    func webRTCClient(_ client: MyWebRTCClient, didReceiveData data: Data) {
        
        //let message = String(data: data, encoding: .utf8) ?? "(Binary: \(data.count) bytes)"
        
        let message: Message
        do {
            //let data = Data(string.utf8)
            message = try self.decoder.decode(Message.self, from: data)
            print("Succeeded")
        }
        catch {
            print("Could not decode message")
            return
        }
        
        for room in chatRooms {
            if room.partner.username == message.from {
                room.addMessage(message: message)
                break
            } else if room.partner.username == message.to {
                room.addMessage(message: message)
                break
            }
        }
        
        let notification = Notification.init(name: MessageHandler.onNewMessage, object: nil, userInfo: [
            MessageHandler.messageUserInfoKey: message
        ])
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
        
//        let alert = UIAlertController(title: "Message from WebRTC", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        
        
    }
}

