//
//  RegisterVCLayout.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 11/1/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class RegisterVCLayout: BaseViewControllerLayout {
    
    lazy var txtFEmail: UITextField = {
        let temp = UITextField()
        temp.keyboardType = UIKeyboardType.emailAddress
        temp.textContentType = .emailAddress
        temp.autocapitalizationType = .none
        temp.placeholder = "Email"
        //temp.font = AppFont.logInTxtFieldContentFont
        temp.clearButtonMode = .whileEditing
        temp.backgroundColor = AppColor.inputBackgroundColor
        temp.layer.cornerRadius = 4
        temp.setLeftPadding(width: 5)
        return temp
    }()

    lazy var txtFPassword: UITextField = {
        let temp = UITextField()
        if #available(iOS 12.0, *) {
            temp.textContentType = .newPassword
        }
        temp.isSecureTextEntry = true
        temp.placeholder = "Password"
        //temp.font = AppFont.logInTxtFieldContentFont
        temp.backgroundColor = AppColor.inputBackgroundColor
        temp.layer.cornerRadius = 4
        temp.setLeftPadding(width: 5)
        return temp
    }()

    lazy var txtFRPassword: UITextField = {
        let temp = UITextField()
        if #available(iOS 12.0, *) {
            temp.textContentType = .newPassword
        }
        temp.isSecureTextEntry = true
        temp.placeholder = "Nhập lại password"
        //temp.font = AppFont.logInTxtFieldContentFont
        temp.backgroundColor = AppColor.inputBackgroundColor
        temp.layer.cornerRadius = 4
        temp.setLeftPadding(width: 5)
        return temp
    }()
    
    let btnRegister: ActivityIndicatorButton = {
        let temp = ActivityIndicatorButton()
        temp.backgroundColor = .darkGray
        temp.setTitle("Đăng ký", for: .normal)
        temp.setTitleColor(.white, for: .normal)
        //temp.titleLabel?.font = AppFont.logInButtonTitleFont
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.addTarget(self, action: #selector(onBtnRegisterTapped), for: .touchUpInside)
        return temp
    }()
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        navigationItem.title = AppString.register
    }
    
    override func setUpLayout() {
        super.setUpLayout()
        view.backgroundColor = .black

        let centerView = UIView()
        centerView.addSubviews(subviews: txtFEmail, txtFPassword, txtFRPassword, btnRegister)
        centerView.addSameConstraintsWith(format: "H:|-10-[v0]-10-|", for: txtFEmail, txtFPassword, btnRegister, txtFRPassword)
        centerView.addConstraintsWith(format: "V:|[v0]-10-[v1]-10-[v2]-30-[v3]-10-|", views: txtFEmail, txtFPassword, txtFRPassword, btnRegister)
        centerView.addSameConstraintsWith(format: "V:[v0(\(AppConstant.heightOfLoginButton))]", for: txtFEmail, txtFPassword, txtFRPassword, btnRegister)

        btnRegister.layer.cornerRadius = AppConstant.heightOfLoginButton/2
        btnRegister.setIndicatorViewFrame(width: widthOfScreen - 20, height: AppConstant.heightOfLoginButton)

        view.addSubviews(subviews: centerView)
        centerView.makeFullWidthWithSuperView()
        centerView.centerYAnchor(with: view)
        
    }

    func startRequestAnimation() {
        btnRegister.startAnimating()
        view.isUserInteractionEnabled = false
    }

    func stopRequestAnimation() {
        btnRegister.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    @objc func onBtnRegisterTapped() {
        view.endEditing(true)
        //check user input
        
        //email address
        //password confirm
        
        print("Hello")
    }
}
