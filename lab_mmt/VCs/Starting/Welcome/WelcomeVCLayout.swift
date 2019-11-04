//
//  LoginVCLayout.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/11/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit

class WelcomeVCLayout: BaseViewControllerLayout, UITextViewDelegate {
    
    /// Defines strings are used for UI, should be grouped in a string resource file.
    
    static let strTitle = "Tham gia trò chuyện với mọi người để cảm thấy thoải mái hơn."
    static let strStart = "Bắt đầu"
    static let strAccount = "Bạn đã có tài khoản? "
    //static let strLogin = "Đăng nhập"
    
    /// end define
    
    let coverView: UIView = {
        let temp = UIView()
        temp.backgroundColor = .black
        temp.isHidden = true
        return temp
    }()
    
    let imgVLogo: UIImageView = {
        let temp = UIImageView()
        temp.backgroundColor = .clear
        temp.contentMode = .scaleAspectFit
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = AppIcon.appIcon
        temp.isHidden = true
        return temp
    }()
    
    let lblTitle: UILabel = {
        let temp = UILabel()
        temp.textAlignment = .left
        temp.font = AppFont.startVCLblTitleFont
        temp.text = WelcomeVCLayout.strTitle
        temp.numberOfLines = 0
        return temp
    }()
    
    let butRegister: UIButton = {
        let temp = UIButton()
        temp.setTitle(WelcomeVCLayout.strStart, for: .normal)
        temp.backgroundColor = AppColor.themeColor
        temp.setTitleColor(.white, for: .normal)
        temp.titleLabel?.font = AppFont.logInButtonTitleFont
        return temp
    }()

    let txtVLogin: UITextView = {
        let temp = UITextView()
        temp.backgroundColor = .clear
        temp.isScrollEnabled = false
        temp.isEditable = false
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()

    var isFirstLoad = true
    let loadIndicator: UIActivityIndicatorView = {
        let temp = UIActivityIndicatorView()
        temp.color = .white
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    let bottomSpacingOfTxtVLogin: CGFloat = {
        switch AppConstant.myScreenType {
        case .iPhoneX: return 55
        default: return 30
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setUpTxtVLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBarHidden(isHidden: true)
    }
    
    let vContentSignUp = UIView()
    override func setUpLayout() {
        super.setUpLayout()
        
        view.addSubviews(subviews: vContentSignUp, loadIndicator, imgVLogo, txtVLogin)
        
        view.addSubview(coverView)
        coverView.makeFullWithSuperView()
        
        do { // content view
            vContentSignUp.addSubviews(subviews: lblTitle, butRegister)
            vContentSignUp.makeCenter(with: view)
            vContentSignUp.makeFullWidthWithSuperView()
            vContentSignUp.addConstraintsWith(format: "V:|[v0]-20-[v1]|", views: lblTitle, butRegister)
        }
        
        do { // lblTitle
            lblTitle.widthAnchor(equalTo: vContentSignUp.widthAnchor, multiplier: 0.8)
            lblTitle.centerXAnchor(with: vContentSignUp)
        }
        
        do { // butRegister
            butRegister.height(constant: 40)
            butRegister.layer.cornerRadius = 20
            butRegister.widthAnchor(equalTo: lblTitle.widthAnchor)
            butRegister.centerXAnchor(with: vContentSignUp)
        }
        
        do { // imgVLogo
            imgVLogo.leftAnchor(equalTo: lblTitle.leftAnchor)
            imgVLogo.topAnchor(equalTo: view.topAnchor, constant: 64)
            imgVLogo.makeSquare(size: 50)
        }
        
        do { // txtVLogin
            txtVLogin.bottomAnchor(equalTo: view.bottomAnchor, constant: -bottomSpacingOfTxtVLogin)
            txtVLogin.centerXAnchor(with: vContentSignUp)
        }
    }
    
    func setUpTxtVLogin() {
        txtVLogin.delegate = self
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let string = NSMutableAttributedString.init(string: WelcomeVCLayout.strAccount, attributes: [NSAttributedString.Key.font: UIFont.avenirNext(size: 16, type: .regular), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: paragraph])
    
        let loginText = NSAttributedString.init(string: AppString.login, attributes: [NSAttributedString.Key.link: "", NSAttributedString.Key.font: UIFont.avenirNext(size: 16, type: .medium), NSAttributedString.Key.foregroundColor: AppColor.themeColor])
        
        string.append(loginText)
        
        txtVLogin.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: AppColor.themeColor])
        txtVLogin.attributedText = string
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
