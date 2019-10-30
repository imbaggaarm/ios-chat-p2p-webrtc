//
//  LoginVC.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/28/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//


import UIKit

class LoginVC: LoginVCLayout, UITextFieldDelegate {

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
    
    deinit {
        print(#function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        changeBtnLoginState(isEnabled: false)

        txtFUsername.delegate = self
        txtFPassword.delegate = self

        txtFUsername.addTarget(self, action: #selector(checkEnableBtnLogin), for: .editingChanged)
        txtFPassword.addTarget(self, action: #selector(checkEnableBtnLogin), for: .editingChanged)
        
    }

    override func onBtnLoginTap() {
        super.onBtnLoginTap()
        view.endEditing(true)

        let username = txtFUsername.text!.lowercased()
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
                    UserProfile.this = response.data!
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
                    print(myFriends)
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
        let mainVC = MainTabBarController(signalClient: signalClient, webRTCClient: webRTCClient)
        mainVC.modalPresentationStyle = .overCurrentContext
        present(mainVC, animated: false) {[unowned self] in
            self.stopRequestAnimation()
        }
    }

    @objc func checkEnableBtnLogin() {
        let isTxtEmailEmpty = (txtFUsername.text?.isEmpty)!
        let isTxtPasswordEmpty = (txtFPassword.text?.isEmpty)!

        changeBtnLoginState(isEnabled: !isTxtEmailEmpty && !isTxtPasswordEmpty)
    }

    func changeBtnLoginState(isEnabled: Bool) {
        btnLogin.isEnabled = isEnabled
        btnLogin.backgroundColor = isEnabled ? AppColor.themeColor : .darkGray
    }

    //MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFUsername {
            //active txtFPassword
            txtFPassword.becomeFirstResponder()
        } else if textField == txtFPassword {
            if (txtFUsername.text!.isEmpty) {
                txtFUsername.becomeFirstResponder()
            } else {
                if btnLogin.isEnabled { //check if should call tap handle at bottom
                    onBtnLoginTap()
                }
            }
        }
        return true
    }
}
