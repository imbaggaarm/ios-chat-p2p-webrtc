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
    
    // define a variable to store initial touch position
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = AppUserDefaults.sharedInstance
        if let strAccount = userDefaults.getUserAccount() {
            let email = strAccount.email
            txtFEmail.text = email
            txtFPassword.becomeFirstResponder()
        } else {
            txtFEmail.becomeFirstResponder()
        }
        
        changeBtnLoginState(isEnabled: false)
        
        txtFEmail.delegate = self
        txtFPassword.delegate = self
        
        txtFEmail.addTarget(self, action: #selector(checkEnableBtnLogin), for: .editingChanged)
        txtFPassword.addTarget(self, action: #selector(checkEnableBtnLogin), for: .editingChanged)
        
        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeGestureRecognizerHandler(_:)))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func swipeGestureRecognizerHandler(_ sender: UISwipeGestureRecognizer) {
        dismissMySelf()
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
                    UserProfile.this.email = response.data!.email
                    UserProfile.this.username = response.data!.username
                    UserProfile.this.token = response.data!.token
                    AppUserDefaults.sharedInstance.setUserAccount(email: email, password: password)
                    self?.getUserProfile()
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
    
    func getUserProfile() {
        
        APIClient.getUserProfile(username: UserProfile.this.username)
            .execute(onSuccess: {[weak self] (response) in
                if response.success {
                    UserProfile.this.copy(from: response.data!)
                    self?.dismissToWelcomeVC()
                } else {
                    self?.stopRequestAnimation()
                    self?.handleError(error: response.error)
                }
            }) {[weak self] (error) in
                self?.stopRequestAnimation()
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
