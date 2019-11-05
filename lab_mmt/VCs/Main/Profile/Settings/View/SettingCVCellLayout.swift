//
//  AccountSettingCVCellLayout.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/13/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit


class SettingCVCellLayout: IMBBaseCollectionViewCell {
    
    let imgV: UIImageView = {
        let temp = UIImageView()
        temp.contentMode = .scaleAspectFit
        temp.backgroundColor = AppColor.black
        temp.isHidden = true
        return temp
    }()
    
    let lblTitle: UILabel = {
        let temp = UILabel()
        temp.textColor = AppColor.accountSettingVCCellLblTitleNormalTxtColor
        temp.font = AppFont.accountSettingCVCellLblTitleFont
        temp.backgroundColor = AppColor.black
        return temp
    }()
    
    let butAtRightCorner: UIButton = {
        let temp = UIButton()
        temp.backgroundColor = AppColor.black
        temp.setImage(AppIcon.settingCVButAtRightCornerIcon, for: .normal)
        return temp
    }()
    
    var shouldShowButAtRightCorner: Bool = true {
        didSet {
            butAtRightCorner.isHidden = shouldShowButAtRightCorner
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.borderColor = AppColor.accountSettingVCCellContentViewBorderColor.cgColor
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpLayout() {
        super.setUpLayout()
        
        contentView.addSubviews(subviews: imgV, lblTitle, butAtRightCorner)
        
        contentView.addConstraintsWith(format: "H:|-24-[v0]-12-[v1]-12-|", views: lblTitle, butAtRightCorner)
        
        // imgV
        do {
            imgV.makeSquare(size: 15)
            imgV.centerYAnchor(with: contentView)
        }
        
        // lblTitle
        do {
            lblTitle.centerYAnchor(with: contentView)
        }
        
        //butAtRightCorner
        do {
            butAtRightCorner.makeSquare(size: 15)
            butAtRightCorner.centerYAnchor(with: contentView)
        }
    }
    
}
