//
//  LaunchVC.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/11/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit

class LaunchVC: LaunchVCLayout {

    let signalClient: SignalingClient
    let webRTCClient: MyWebRTCClient
    
    init(signalClient: SignalingClient, webRTCClient: MyWebRTCClient) {
        self.signalClient = signalClient
        self.webRTCClient = webRTCClient
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
        let vc = MainTabBarController(signalClient: signalClient, webRTCClient: webRTCClient)
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false) {[unowned self] in
            self.stopRequestAnimation()
        }
    }
    
    private func showLoginVC() {
        let vc = LoginVC(signalClient: signalClient, webRTCClient: webRTCClient)
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
                    UserProfile.this = response.data!
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
                    print(myFriends)
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
    

}
