//
//  SettingDescribeView.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/13/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit

class SettingDescribeView: IMBVerticalLabelView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let describeTextAlignment: NSTextAlignment = .center
        
        lblTitle.textColor = AppColor.white
        font = AppFont.settingVCDescribeTextFont
        textAlignment = describeTextAlignment
        lblTitle.numberOfLines = 0
        titleColor = AppColor.settingVCDescribeTextColor
        lblTitle.backgroundColor = .clear
        setLeftAndRightInsetsOfTopView(left: 10, right: 10)
        spacing = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }
}

class SettingTextField: IMBTextField {
    
    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString.init(string: placeholder ?? "", attributes: [NSAttributedString.Key.font: AppFont.settingVCTxtFTextFont, NSAttributedString.Key.foregroundColor: AppColor.settingVCTxtFPlaceHolderColor])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let settingTxtFLeftPadding: CGFloat = 10
        let heightOfTextFieldInSettingVC: CGFloat = 50
        
        setLeftPadding(width: settingTxtFLeftPadding)
        font = AppFont.settingVCTxtFTextFont
        textColor = AppColor.settingVCTxtFTextColor
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: heightOfTextFieldInSettingVC).isActive = true
        backgroundColor = AppColor.black
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDisable() {
        self.isEnabled = false
        self.alpha = 0.7
    }
    
    
}
