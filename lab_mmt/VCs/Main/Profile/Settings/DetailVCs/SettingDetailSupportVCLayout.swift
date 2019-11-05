//
//  SettingDetailSupportVCLayout.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/13/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit


class SettingDetailSupportVCLayout: BaseViewControllerLayout {
    
    lazy var supportView: SettingDescribeView = {
        let temp = SettingDescribeView()
        temp.bottomView.backgroundColor = AppColor.btnBackgroundColor
        return temp
    }()
    
    let lblEmail: UILabel = {
        let temp = UILabel()
        temp.backgroundColor = .clear
        temp.font = AppFont.accountSettingCVCellLblTitleFont
        temp.textColor = AppColor.white
        temp.textAlignment = .center
        return temp
    }()
    
    let butSendSupportEmail: UIButton = {
        let temp = UIButton()
        temp.backgroundColor = AppColor.btnBackgroundColor
        temp.titleLabel?.font = AppFont.logInButtonTitleFont
        temp.setTitleColor(AppColor.themeColor, for: .normal)
        return temp
    }()
    
    lazy var reportBugsView: SettingDescribeView = {
        let temp = SettingDescribeView()
        temp.bottomView.backgroundColor = AppColor.btnBackgroundColor
        return temp
    }()
    
    let lblReportBug: UILabel = {
        let temp = UILabel()
        temp.backgroundColor = .clear
        temp.font = AppFont.accountSettingCVCellLblTitleFont
        temp.textColor = AppColor.white
        temp.textAlignment = .center
        return temp
    }()

    let butReportBug: UIButton = {
        let temp = UIButton()
        temp.backgroundColor = AppColor.btnBackgroundColor
        temp.titleLabel?.font = AppFont.logInButtonTitleFont
        temp.setTitleColor(AppColor.redOrangeColor, for: .normal)
        return temp
    }()
    
    lazy var fanpageView: SettingDescribeView = {
        let temp = SettingDescribeView()
        temp.bottomView.backgroundColor = AppColor.btnBackgroundColor
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColor.black
        
        fanpageView.title = "Nếu bạn cần hỗ trợ, hoặc phát hiện lỗi trong ứng dụng, hãy liên hệ với chúng tôi qua fanpage: BKSchedule"
        supportView.title = "Hoặc bạn có thể liên hệ với chúng tôi qua email:"
        lblEmail.text = AppString.supportEmail
        butSendSupportEmail.setTitle("Gửi email Hỗ trợ", for: .normal)
        
        reportBugsView.title = "Thông báo lỗi qua email:"
        lblReportBug.text = AppString.reportBugEmail
        butReportBug.setTitle("Thông báo lỗi", for: .normal)
    }
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        
        title = AppString.detailSettingSupportVCTitle
    }
    
    let heightOfTextFieldInSettingVC: CGFloat = 50
    
    override func setUpLayout() {
        super.setUpLayout()
        
        view.addSubviews(subviews: fanpageView, supportView, reportBugsView)
        view.addConstraintsWith(format: "V:[v0]-10-[v1]-[v2]", views: fanpageView, supportView, reportBugsView)
        fanpageView.topAnchor(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20)
        
        do {
            fanpageView.bottomView.addSubview(btnOpenFanpage)
            btnOpenFanpage.translatesAutoresizingMaskIntoConstraints = false
            btnOpenFanpage.height(constant: heightOfTextFieldInSettingVC)
            btnOpenFanpage.makeFullWithSuperView()
            fanpageView.makeFullWidthWithSuperView()
        }

        do {
            supportView.bottomView.addSubview(lblEmail)
            supportView.bottomView.addSubview(butSendSupportEmail)
            supportView.bottomView.addConstraintsWith(format: "V:|[v0(v1)][v1(\(heightOfTextFieldInSettingVC))]|", views: lblEmail, butSendSupportEmail)
            supportView.makeFullWidthWithSuperView()
            supportView.addConstraintsWith(format: "H:|-10-[v0]-10-|", views: lblEmail)
        }
        
        do {
            reportBugsView.bottomView.addSubview(lblReportBug)
            reportBugsView.bottomView.addSubview(butReportBug)
            reportBugsView.bottomView.addConstraintsWith(format: "V:|[v0(v1)][v1(\(heightOfTextFieldInSettingVC))]|", views: lblReportBug, butReportBug)
            reportBugsView.makeFullWidthWithSuperView()
            reportBugsView.addConstraintsWith(format: "H:|-10-[v0]-10-|", views: lblReportBug)
        }
        
        do {
            butSendSupportEmail.heightAnchor.constraint(equalToConstant: heightOfTextFieldInSettingVC).isActive = true
            butSendSupportEmail.makeFullWidthWithSuperView()
        }
        
        do {
            butReportBug.heightAnchor.constraint(equalToConstant: heightOfTextFieldInSettingVC).isActive = true
            butReportBug.makeFullWidthWithSuperView()
        }
    }
    
}
