//
//  SettingDetailAppInfoVCLayout.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/13/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit

class SettingDetailAppInfoVCLayout: BaseViewControllerLayout {
    
    var appVersion: String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return "v\(version)"
    }
    
    lazy var contactView: SettingDescribeView = {
        let temp = SettingDescribeView()
        temp.bottomView.backgroundColor = AppColor.btnBackgroundColor
        return temp
    }()
    
    let lblEmail: UILabel = {
        let temp = UILabel()
        temp.backgroundColor = .clear
        temp.font = AppFont.accountSettingCVCellLblTitleFont
        temp.textColor = AppColor.settingVCTxtFTextColor
        temp.textAlignment = .center
        return temp
    }()
    
    let butSendContactEmail: UIButton = {
        let temp = UIButton()
        temp.backgroundColor = AppColor.btnBackgroundColor
        temp.titleLabel?.font = AppFont.logInButtonTitleFont
        temp.setTitleColor(AppColor.themeColor, for: .normal)
        temp.setTitle("Gửi email liên hệ", for: .normal)
        return temp
    }()
    
    lazy var fanpageView: SettingDescribeView = {
        let temp = SettingDescribeView()
        temp.bottomView.backgroundColor = .darkGray
        return temp
    }()
    
    let btnOpenFanpage: UIButton = {
        let temp = UIButton()
        temp.backgroundColor = AppColor.btnBackgroundColor
        temp.titleLabel?.font = AppFont.logInButtonTitleFont
        temp.setTitleColor(AppColor.themeColor, for: .normal)
        temp.setTitle("Mở Messenger", for: .normal)
        return temp
    }()
    
    let lblCredit: UILabel = {
        let temp = UILabel()
        temp.font = AppFont.settingVCDescribeTextFont
        temp.textAlignment = .center
        temp.numberOfLines = 0
        temp.textColor = AppColor.settingVCDescribeTextColor
        temp.backgroundColor = .clear
        return temp
    }()
    
    let lblAppVersion: UILabel = {
        let temp = UILabel()
        temp.font = UIFont.avenirNext(size: 12, type: .regular)
        temp.textAlignment = .center
        temp.numberOfLines = 0
        temp.textColor = AppColor.settingVCDescribeTextColor
        temp.backgroundColor = .clear
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColor.black
        
        fanpageView.title = "BKSchedule là sản phẩm của Baggarm Team. Nếu bạn muốn liên hệ với chúng tôi, xin vui lòng liên lạc qua fanpage: BKSchedule"
        
        contactView.title = "Hoặc bạn có thể liên hệ với chúng tôi qua email:"
        lblEmail.text = AppString.contactEmail
        
        lblCredit.text = "Ứng dụng có đường dẫn đến trang: Thư viện tài liệu Bách Khoa."
        lblAppVersion.text = "Phiên bản " + appVersion + " - Hãy luôn cập nhật phiên bản mới nhất."
    }
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        
        title = AppString.detailSettingAppInfoVCTitle
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }

    }


    let heightOfTextFieldInSettingVC: CGFloat = 50
    override func setUpLayout() {
        super.setUpLayout()
        
        view.addSubviews(subviews: contactView, lblCredit, lblAppVersion, fanpageView)
        view.addConstraintsWith(format: "V:[v0]-20-[v1]-20-[v2]", views: fanpageView, contactView, lblCredit)
        
        fanpageView.topAnchor(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20)
        
        do {
            contactView.bottomView.addSubview(lblEmail)
            contactView.bottomView.addSubview(butSendContactEmail)
            contactView.bottomView.addConstraintsWith(format: "V:|[v0(v1)][v1(\(heightOfTextFieldInSettingVC))]|", views: lblEmail, butSendContactEmail)
            contactView.makeFullWidthWithSuperView()
            contactView.addConstraintsWith(format: "H:|-10-[v0]|", views: lblEmail)
        }
        
        do {
            butSendContactEmail.makeFullWidthWithSuperView()
        }
        
        do {
            fanpageView.bottomView.addSubview(btnOpenFanpage)
            btnOpenFanpage.translatesAutoresizingMaskIntoConstraints = false
            btnOpenFanpage.height(constant: heightOfTextFieldInSettingVC)
            btnOpenFanpage.makeFullWithSuperView()
            fanpageView.makeFullWidthWithSuperView()
        }
        
        do {
            view.addConstraintsWith(format: "H:|-10-[v0]-10-|", views: lblCredit)
        }
        
        do {
            lblAppVersion.translatesAutoresizingMaskIntoConstraints = false
            if #available(iOS 11.0, *) {
                lblAppVersion.bottomAnchor(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
            } else {
                lblAppVersion.bottomAnchor(equalTo: view.bottomAnchor, constant: -5)
            }
            
            lblAppVersion.makeFullWidthWithSuperView()
        }
    }

}
