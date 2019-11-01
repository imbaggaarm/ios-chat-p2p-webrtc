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
}
