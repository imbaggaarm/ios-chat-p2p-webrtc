//
//  MainTabbarVC.swift
//  unichat
//
//  Created by Imbaggaarm on 10/13/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit
import WebRTC

class LoadingView: UIView {
    let loadIndicator: UIActivityIndicatorView = {
        let temp = UIActivityIndicatorView()
        temp.color = .white
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = AppColor.black
        
        addSubviews(subviews: loadIndicator)
        
        loadIndicator.makeSquare(size: 40)
        loadIndicator.makeCenter(with: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainTabbarVC: UITabBarController {
    
    let signalClient: SignalingClient
    let webRTCClient: WebRTCClient
    let decoder = JSONDecoder()
    
    init(signalClient: SignalingClient, webRTCClient: WebRTCClient) {
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
        
        let friendsVC = UINavigationController.init(rootViewController: FriendsVC())
        friendsVC.tabBarItem.image = AppIcon.tabbarFriends
        
        viewControllers = [chatListNVC, friendsVC]
        
        selectedIndex = 0
        
        for vc in viewControllers! {
            vc.tabBarItem.title = nil
            vc.tabBarItem.imageInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: -6, right: 0)
        }
        
        setUpLayout()
    }
    
    
    let loadingView = LoadingView()
    func setUpLayout() {
        view.addSubview(loadingView)
        loadingView.makeFullWithSuperView()
        loadingView.loadIndicator.startAnimating()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    
    deinit {
        print(self.description + #function)
    }
}

extension MainTabbarVC: SignalClientDelegate {
    
    func createChatRooms() {
        for friend in myFriends {
            let room = ChatRoom.init(id: friend.username, partner: friend)
            chatRooms.append(room)
        }
    }
    
    func getUserProfileAndFriendList() {
        APIClient.getUserFriends(username: UserProfile.this.username)
            .execute(onSuccess: {[weak self] (response) in
                if self == nil { return }
                if response.success {
                    DispatchQueue.main.async {
                        myFriends = response.data!
                        
                        self!.createChatRooms()
                        
                        for friend in myFriends {
                            friend.setP2pState()
                        }
                        
                        //reload chatlistvc
                        if let nav = self!.selectedViewController as? UINavigationController {
                            if let chatListVC = nav.topViewController as? ChatListVC {
                                chatListVC.reloadData()
                            }
                        }
                        
                        for friend in myFriends {
                            //only establish connection for friend is online
                            if friend.state == .online {
                                let peerConnection = self!.webRTCClient.createPeerConnection(for: friend.username)
                                self!.webRTCClient.offer(peerConnection: peerConnection) { (sdp) in
                                    self!.signalClient.sendOffer(username: UserProfile.this.username, partnerUsername: friend.username, sdp: sdp)
                                }
                            }
                        }
                        self?.loadingView.removeFromSuperview()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.loadingView.removeFromSuperview()
                        self?.letsAlert(withMessage: response.error)
                    }
                }
            }) {[weak self] (err) in
                DispatchQueue.main.async {
                    self?.loadingView.removeFromSuperview()
                    self?.letsAlert(withMessage: err.asAFError?.errorDescription ?? "Không thể lấy danh sách bạn, hãy thử đăng nhập lại.")
                }
        }
    }
    
    func signalClientDidConnect(_ signalClient: SignalingClient) {
        getUserProfileAndFriendList()
    }
    
    func signalClientDidDisconnect(_ signalClient: SignalingClient) {
        //self.signalingConnected = false
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
    
    func signalClient(_ signalClient: SignalingClient, didReceiveOnlineState onlineState: WSOnlineState, fromUser userID: UserID) {
        print("Received online state changed")
        for friend in myFriends {
            if friend.username == userID {
                friend.state = onlineState
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: MessageHandler.onPeerConnectionChanging, object: nil, userInfo: nil)
                }
                break
            }
        }
    }
    
    func signalClient(_ signalClient: SignalingClient, didReceiveFailedOfferFromUser userID: UserID) {
        print("Received failed offer")
        self.webRTCClient.removePeerConnection(forUser: userID)
    }
    
    func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate, fromUser userID: UserID) {
        print("Received remote candidate")
        //self.remoteCandidateCount += 1
        self.webRTCClient.set(remoteCandidate: candidate, for: userID)
    }
}

extension MainTabbarVC: WebRTCClientDelegate {
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate, forUser userID: UserID) {
        print("discovered local candidate")
        //self.localCandidateCount += 1
        self.signalClient.send(candidate: candidate, toUser: userID)
        //        print(candidate)
    }
    
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
    
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: MessageHandler.onPeerConnectionChanging, object: nil, userInfo: nil)
        }
    }
    
    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) {
        
        //let message = String(data: data, encoding: .utf8) ?? "(Binary: \(data.count) bytes)"
        
        var message: Message
        do {
            //let data = Data(string.utf8)
            message = try self.decoder.decode(Message.self, from: data)
        }
        catch {
            print("Could not decode message")
            return
        }
        
        //print message that has just received
        print(message)
        for room in chatRooms {
            if room.partner.username == message.from {
                switch message.message {
                case .attachment(let attachment):
                    //append to old
                    
                    for i in stride(from: room.messages.count - 1, through: 0, by: -1) {
                        let mes = room.messages[i]
                        if message.id == mes.id {
                            switch mes.message {
                            case .attachment(var attach):
                                attach.payload += attachment.payload
                                attach.currentPackage = attachment.currentPackage
                                message = Message.init(id: mes.id, from: mes.from, to: mes.to, createdTime: mes.createdTime, message: MessagePayload.attachment(attach))
                                room.messages[i] = message
                                if i == room.messages.count - 1 {
                                    room.lastMessage = message
                                }
                                break
                            default:
                                break
                            }
                            break
                        }
                    }
                    if attachment.currentPackage == 1 {
                        room.addMessage(message: message)
                    }
                default:
                    room.addMessage(message: message)
                    break
                }
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

