//
//  LoginVC.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/28/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//


import UIKit

class showWelcomVC: LoginVCLayout, UITextFieldDelegate {

    var signalClient: SignalingClient?
    var webRTCClient: WebRTCClient?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(#function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        changeBtnLoginState(isEnabled: false)

        txtFEmail.delegate = self
        txtFPassword.delegate = self

        txtFEmail.addTarget(self, action: #selector(checkEnableBtnLogin), for: .editingChanged)
        txtFPassword.addTarget(self, action: #selector(checkEnableBtnLogin), for: .editingChanged)
    }

    override func onBtnLoginTap() {
        super.onBtnLoginTap()
        view.endEditing(true)

        let username = txtFEmail.text!.lowercased()
        let password = txtFPassword.text!
        
        startRequestAnimation()
        login(email: username, password: password)
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
                    self?.handleError(error: response.error)
                }
            case .failure(let error):
                self?.handleError(error: error.errorDescription ?? "Unexpected error")
                print(error)
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
                    if isGotProfile {
                        self?.stopRequestAnimation()
                    }
                    self?.handleError(error: response.error)
                }
            case .failure(let error):
                if isGotProfile {
                    self?.stopRequestAnimation()
                }
                self?.handleError(error: error.errorDescription ?? "Unexpected error")
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
                    if isGotProfile {
                        self?.stopRequestAnimation()
                    }
                    self?.handleError(error: response.error)
                }
            case .failure(let error):
                if isGotProfile {
                    self?.stopRequestAnimation()
                }
                self?.handleError(error: error.errorDescription ?? "Unexpected error")
            }
        }
    }
    
    private func showMainVC() {
        webRTCClient = WebRTCClient(iceServers: Config.default.webRTCIceServers)
        signalClient = self.buildSignalingClient()
        let mainVC = MainTabbarVC(signalClient: signalClient!, webRTCClient: webRTCClient!)
        mainVC.modalPresentationStyle = .overFullScreen
        present(mainVC, animated: false) {[unowned self] in
            self.stopRequestAnimation()
        }
    }

    @objc func checkEnableBtnLogin() {
        let isTxtEmailEmpty = (txtFEmail.text?.isEmpty)!
        let isTxtPasswordEmpty = (txtFPassword.text?.isEmpty)!

        changeBtnLoginState(isEnabled: !isTxtEmailEmpty && !isTxtPasswordEmpty)
    }

    func changeBtnLoginState(isEnabled: Bool) {
        btnLogin.isEnabled = isEnabled
        btnLogin.backgroundColor = isEnabled ? AppColor.themeColor : .darkGray
    }

    //MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFEmail {
            //active txtFPassword
            txtFPassword.becomeFirstResponder()
        } else if textField == txtFPassword {
            if (txtFEmail.text!.isEmpty) {
                txtFEmail.becomeFirstResponder()
            } else {
                if btnLogin.isEnabled { //check if should call tap handle at bottom
                    onBtnLoginTap()
                }
            }
        }
        return true
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
