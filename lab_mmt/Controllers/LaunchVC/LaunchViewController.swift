//
//  LaunchViewController.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/11/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit

class LaunchViewController: LaunchViewControllerLayout {

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
        setStatusBarHidden(isHidden: true)
        loadConfigData()
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
        }
    }
    
    func autoLogin(email: String, password: String) {
        
    }
    
    private func showMainVC() {
        let vc = MainTabBarController(signalClient: signalClient, webRTCClient: webRTCClient)
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }
    
    private func showLoginVC() {
        let vc = LoginVC(signalClient: signalClient, webRTCClient: webRTCClient)
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }
    
}
