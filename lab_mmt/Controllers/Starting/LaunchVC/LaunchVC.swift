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
        let userDefaults = AppUserDefaults.sharedInstance
        
        //handle autologin to load data
        if let strAccount = userDefaults.getUserAccount() {
            let email = strAccount.email
            let password = strAccount.password
            
            //login with username and password
            if !email.isEmpty {
                //auto login
                autoLogin(email: email, password: password)
            } else {
                //show loginvc
                showLoginVC()
            }
        } else {
            //show loginvc
            showLoginVC()
        }
    }
    
    func autoLogin(email: String, password: String) {
        login(email: email, password: password)
    }
    
    private func showMainVC() {
        webRTCClient = WebRTCClient(iceServers: Config.default.webRTCIceServers)
        signalClient = self.buildSignalingClient()
        
        let vc = MainTabbarVC(signalClient: signalClient!, webRTCClient: webRTCClient!)
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false) {[unowned self] in
            self.stopRequestAnimation()
        }
    }
    
    private func showLoginVC() {
        let vc = LoginVC()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false) {[unowned self] in
            self.stopRequestAnimation()
        }
    }
    
    
    private func login(email: String, password: String) {
        APIClient.login(email: email, password: password) {[weak self] (result) in

            switch result {
            case .success(let response):
                if response.success {
                    UserProfile.this.email = email
                    UserProfile.this.username = response.data!.username
                    UserProfile.this.jwt = response.data!.jwt
                    AppUserDefaults.sharedInstance.setUserAccount(email: email, password: password)
                    self?.getUserProfileAndFriendList()
                } else {
                    self?.showLoginVC()
                }
            case .failure(_):
                self?.showLoginVC()
            }
        }
    }
    
    func handleError(error: String) {
        self.stopRequestAnimation()
        self.letsAlert(withMessage: error)
    }
    
    func getUserProfileAndFriendList() {
        var isGotProfile = false
        var isGotUserFriends = false
        
        APIClient.getUserProfile(username: UserProfile.this.username) {[weak self] (result) in
            isGotProfile = true
            switch result {
            case .success(let response):
                if response.success {
                    UserProfile.this.copy(from: response.data!)
                    if isGotUserFriends {
                        self?.showMainVC()
                    }
                } else {
                    self?.showLoginVC()
                }
            case .failure(_):
                self?.showLoginVC()
            }
        }
        
        APIClient.getUserFriends(username: UserProfile.this.username) {[weak self] (result) in
            isGotUserFriends = true
            switch result {
            case .success(let response):
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
                    self?.showLoginVC()
                }
            case .failure(_):
                self?.showLoginVC()
            }
        }
    }
    
    private func buildSignalingClient() -> SignalingClient {
        
        // iOS 13 has native websocket support. For iOS 12 or lower we will use 3rd party library.
        let webSocketProvider: WebSocketProvider
        let url = URL.init(string: Config.default.signalingServerUrlStr + "?token=\(UserProfile.this.jwt)")!
        if #available(iOS 13.0, *) {
            webSocketProvider = NativeWebSocket(url: url)
        } else {
            webSocketProvider = StarscreamWebSocket(url: url)
        }
        
        return SignalingClient(webSocket: webSocketProvider)
    }

}
