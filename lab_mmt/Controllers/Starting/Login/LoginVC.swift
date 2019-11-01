//
//  LoginVC.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/28/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//


import UIKit

class LoginVC: LoginVCLayout, UITextFieldDelegate {
    
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
        
        let userDefaults = AppUserDefaults.sharedInstance
        if let strAccount = userDefaults.getUserAccount() {
            let email = strAccount.email
            txtFEmail.text = email
        }
        
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
        APIClient.login(email: email, password: password)
            .execute(onSuccess: {[weak self] (response) in
                if response.success {
                    UserProfile.this.email = email
                    UserProfile.this.username = response.data!.username
                    UserProfile.this.jwt = response.data!.jwt
                    AppUserDefaults.sharedInstance.setUserAccount(email: email, password: password)
                    self?.getUserProfileAndFriendList()
                } else {
                    self?.handleError(error: response.error)
                }
            }) {[weak self] (error) in
                self?.handleError(error: error.asAFError?.errorDescription ?? "Unexpected error")
                print(error)
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
                        self?.dismissToWelcomeVC()
                    }
                } else {
                    if isGotUserFriends {
                        self?.stopRequestAnimation()
                    }
                    self?.handleError(error: response.error)
                }
            }) {[weak self] (error) in
                isGotProfile = true
                if isGotUserFriends {
                    self?.stopRequestAnimation()
                }
                self?.handleError(error: error.asAFError?.errorDescription ?? "Unexpected error")
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
                        self?.dismissToWelcomeVC()
                    }
                } else {
                    if isGotProfile {
                        self?.stopRequestAnimation()
                    }
                    self?.handleError(error: response.error)
                }
            }) {[weak self] (error) in
                isGotUserFriends = true
                if isGotProfile {
                    self?.stopRequestAnimation()
                }
                self?.handleError(error: error.asAFError?.errorDescription ?? "Unexpected error")
        }
    }
    
    private func dismissToWelcomeVC() {
        if let welcomeVC = presentingViewController as? WelcomeVC {
            welcomeVC.shouldPresentMainVC = true
            dismiss(animated: false) {
                welcomeVC.presentMainVC()
            }
            return
        }
        
        dismiss(animated: false, completion: nil)
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
}
