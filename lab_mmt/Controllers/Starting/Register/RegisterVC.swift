//
//  RegisterVC.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 11/1/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class RegisterVC: RegisterVCLayout, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFEmail.delegate = self
        txtFPassword.delegate = self
        txtFRPassword.delegate = self
        
        txtFEmail.addTarget(self, action: #selector(checkEnableBtnRegister), for: .editingChanged)
        txtFPassword.addTarget(self, action: #selector(checkEnableBtnRegister), for: .editingChanged)
        txtFRPassword.addTarget(self, action: #selector(checkEnableBtnRegister), for: .editingChanged)
        
        txtFEmail.becomeFirstResponder()
    }
    
    //MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFEmail {
            //active txtFPassword
            txtFPassword.becomeFirstResponder()
        } else if textField == txtFPassword {
            txtFRPassword.becomeFirstResponder()
        } else if textField == txtFRPassword {
            if (txtFEmail.text!.isEmpty) {
                txtFEmail.becomeFirstResponder()
            } else {
                if btnRegister.isEnabled { //check if should call tap handle at bottom
                    onBtnRegisterTapped()
                }
            }
        }
        return true
    }
    
    @objc func checkEnableBtnRegister() {
        let isTxtEmailEmpty = (txtFEmail.text?.isEmpty)!

        let isTxtPasswordEmpty = (txtFPassword.text?.isEmpty)!
        let isTxtRPasswordEmpty = (txtFRPassword.text?.isEmpty)!
        
        changeBtnLoginState(isEnabled: !isTxtEmailEmpty && !isTxtPasswordEmpty && !isTxtRPasswordEmpty)
    }

    func changeBtnLoginState(isEnabled: Bool) {
        btnRegister.isEnabled = isEnabled
        btnRegister.backgroundColor = isEnabled ? AppColor.themeColor : .darkGray
    }
    
    override func onBtnRegisterTapped() {
        super.onBtnRegisterTapped()
        if txtFPassword.text != txtFRPassword.text {
            letsAlert(withMessage: "Mật khẩu không trùng khớp!")
            return
        }
        
        startRequestAnimation()
        APIClient.register(email: txtFEmail.text!, password: txtFPassword.text!)
            .execute(onSuccess: {[weak self] (response) in
                if response.success == true {
                    let email = response.data!.email
                    let password = self!.txtFPassword.text!
                    UserProfile.this.email = email
                    UserProfile.this.username = response.data!.username
                    UserProfile.this.token = response.data!.token
                    AppUserDefaults.sharedInstance.setUserAccount(email: email, password: password)
                    
                    self?.dismissToWelcomeVC()
                } else {
                    self?.letsAlert(withMessage: response.error)
                    self?.stopRequestAnimation()
                }
            }) {[weak self] (error) in
                self?.letsAlert(withMessage: error.asAFError?.errorDescription ?? "Unexpected error!")
                self?.stopRequestAnimation()
        }
        
    }
    
    private func dismissToWelcomeVC() {
        if let welcomeVC = presentingViewController as? WelcomeVC {
            welcomeVC.shouldPresentUpdateProfileVC = true
            dismiss(animated: false) {
                welcomeVC.presentUpdateProfileVC()
            }
            return
        }
        dismiss(animated: false, completion: nil)
    }
}

