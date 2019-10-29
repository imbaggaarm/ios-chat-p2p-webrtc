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
        
        for user in allUsers {
            if user.username == username {
                User.this = user
                break
            }
        }
        
        startRequestAnimation()
        showMainVC()
        stopRequestAnimation()
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
