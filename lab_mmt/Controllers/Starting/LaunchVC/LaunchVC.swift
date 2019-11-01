//
//  LaunchVC.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/11/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit

class LaunchVC: LaunchVCLayout {
    
    var signalClient: SignalingClient?
    var webRTCClient: WebRTCClient?
    
    init() {
        //        self.signalClient = signalClient
        //        self.webRTCClient = webRTCClient
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setStatusBarHidden(isHidden: true)
        loadConfigData()
        startRequestAnimation()
    }
    
    var shouldShowLoginVC: Bool = false
    var isShowing: Bool = false
    
    func loadConfigData() {
        
        //handle autologin to load data
        let userDefaults = AppUserDefaults.sharedInstance
        if let strAccount = userDefaults.getUserAccount() {
            let email = strAccount.email
            let password = strAccount.password
            
            //login with username and password
            if !email.isEmpty {
                //auto login
                autoLogin(email: email, password: password)
            } else {
                //show loginvc
                showWelcomeVC()
            }
        } else {
            //show loginvc
            showWelcomeVC()
        }
    }
    
    func autoLogin(email: String, password: String) {
        login(email: email, password: password)
    }
    
    private func showMainVC() {
        webRTCClient = WebRTCClient(iceServers: Config.default.webRTCIceServers)
        signalClient = SignalingClient()
        
        let vc = MainTabbarVC(signalClient: signalClient!, webRTCClient: webRTCClient!)
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false) {[unowned self] in
            self.stopRequestAnimation()
        }
    }
    
    private func showWelcomeVC() {
        let vc = WelcomeVC()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false) {[unowned self] in
            self.stopRequestAnimation()
        }
    }
    
    private func login(email: String, password: String) {
        APIClient.login(email: email, password: password)
            .execute(onSuccess: {[weak self] (response) in
                if response.success {
                    UserProfile.this.email = email
                    UserProfile.this.username = response.data!.username
                    UserProfile.this.jwt = response.data!.jwt
                    AppUserDefaults.sharedInstance.setUserAccount(email: email, password: password)
                    self?.getUserProfileAndFriendList()
                } else {
                    self?.showWelcomeVC()
                }
            }) {[weak self] (error) in
                self?.showWelcomeVC()
        }
    }
    
    func handleError(error: String) {
        self.stopRequestAnimation()
        self.letsAlert(withMessage: error)
    }
    
    func getUserProfileAndFriendList() {
        var isGotProfile = false
        var isGotUserFriends = false
        
        APIClient.getUserProfile(username: UserProfile.this.username)
            .execute(onSuccess: {[weak self] (response) in
                isGotProfile = true
                if response.success {
                    UserProfile.this.copy(from: response.data!)
                    if isGotUserFriends {
                        self?.showMainVC()
                    }
                } else {
                    self?.showWelcomeVC()
                }
            }) {[weak self] (_) in
                isGotProfile = true
                self?.showWelcomeVC()
        }
        
        
        APIClient.getUserFriends(username: UserProfile.this.username)
            .execute(onSuccess: {[weak self] (response) in
                isGotUserFriends = true
                if response.success {
                    myFriends = response.data!
                    for friend in myFriends {
                        friend.setP2pState()
                    }
                    if isGotProfile {
                        self?.showMainVC()
                        self?.stopRequestAnimation()
                    }
                } else {
                    self?.showWelcomeVC()
                }
            }) {[weak self] (_) in
                isGotUserFriends = true
                self?.showWelcomeVC()
        }
    }
    
    //    private func buildSignalingClient() -> SignalingClient {
    //
    //        // iOS 13 has native websocket support. For iOS 12 or lower we will use 3rd party library.
    //        let webSocketProvider: WebSocketProvider
    //        let url = URL.init(string: Config.default.signalingServerUrlStr + "?token=\(UserProfile.this.jwt)")!
    //        if #available(iOS 13.0, *) {
    //            webSocketProvider = NativeWebSocket(url: url)
    //        } else {
    //            webSocketProvider = StarscreamWebSocket(url: url)
    //        }
    //
    //        return SignalingClient(webSocket: webSocketProvider)
    //    }
    
}
