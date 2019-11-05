//
//  LoginVCLayout.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/28/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class LoginVCLayout: BaseViewControllerLayout {
    
    lazy var txtFEmail: UITextField = {
        let temp = UITextField()
        temp.keyboardType = UIKeyboardType.emailAddress
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
        temp.isSecureTextEntry = true
        temp.placeholder = "Password"
        //temp.font = AppFont.logInTxtFieldContentFont
        temp.backgroundColor = AppColor.inputBackgroundColor
        temp.layer.cornerRadius = 4
        temp.setLeftPadding(width: 5)
        return temp
    }()

    let btnLogin: ActivityIndicatorButton = {
        let temp = ActivityIndicatorButton()
        temp.backgroundColor = .darkGray
        temp.setTitle(AppString.login, for: .normal)
        temp.setTitleColor(.white, for: .normal)
        //temp.titleLabel?.font = AppFont.logInButtonTitleFont
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.addTarget(self, action: #selector(onBtnLoginTap), for: .touchUpInside)
        return temp
    }()

    let imgVLogo: UIImageView = {
        let temp = UIImageView()
        temp.backgroundColor = .clear
        temp.image = AppIcon.appIcon
        temp.contentMode = .scaleAspectFit
        temp.isHidden = true
        return temp
    }()

    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        //setStatusBarHidden(isHidden: true)
        
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = AppString.login
    }

    override func setUpLayout() {
        super.setUpLayout()
        view.backgroundColor = .black

        let loginView = UIView()
        loginView.addSubviews(subviews: txtFEmail, txtFPassword, btnLogin)
        loginView.addSameConstraintsWith(format: "H:|-10-[v0]-10-|", for: txtFEmail, txtFPassword, btnLogin)
        loginView.addConstraintsWith(format: "V:|[v0]-10-[v1]-10-[v2]|", views: txtFEmail, txtFPassword, btnLogin)
        loginView.addSameConstraintsWith(format: "V:[v0(\(AppConstant.heightOfLoginButton))]", for: txtFEmail, txtFPassword, btnLogin)

        btnLogin.layer.cornerRadius = 5
        btnLogin.setIndicatorViewFrame(width: widthOfScreen - 20, height: AppConstant.heightOfLoginButton)

        let vBackgroundOfImgV = UIView()
        vBackgroundOfImgV.addSubview(imgVLogo)
        imgVLogo.makeCenter(with: vBackgroundOfImgV)
        imgVLogo.makeSquare(size: 100)

        view.addSubviews(subviews: loginView, vBackgroundOfImgV)
        loginView.makeFullWidthWithSuperView()
        loginView.centerYAnchor(with: view)

        view.addConstraintsWith(format: "V:|[v0][v1]", views: vBackgroundOfImgV, loginView)
        vBackgroundOfImgV.makeFullWidthWithSuperView()

    }

    @objc func onBtnLoginTap() {

    }

    func startRequestAnimation() {
        btnLogin.startAnimating()
        view.isUserInteractionEnabled = false
    }

    func stopRequestAnimation() {
        btnLogin.stopAnimating()
        view.isUserInteractionEnabled = true
    }
}
