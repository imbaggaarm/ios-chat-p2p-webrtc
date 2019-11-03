//
//  AccountSettingCVCell.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/13/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit

struct SettingCellDetail {
    var icon: UIImage?
    var title: String?
    var isHighlightedTitle: Bool = false
    var isShowButAtRightCorner: Bool = true
    var titleAligment: NSTextAlignment = .left
}

class SettingCVCell: SettingCVCellLayout {
    
    var detail: SettingCellDetail? {
        didSet {
            setUpDetail()
        }
    }
    
    func setUpDetail() {
        if let settingDetail = self.detail {
            if let icon = settingDetail.icon {
                imgV.image = icon
                
            } else {
                imgV.image = nil
            }
            
            if let title = settingDetail.title {
                lblTitle.text = title
            }
            
            if settingDetail.isHighlightedTitle {
                lblTitle.textColor = AppColor.accountSettingVCCellLblTitleHighlightedTxtColor
            } else {
                lblTitle.textColor = AppColor.accountSettingVCCellLblTitleNormalTxtColor
            }
            
            if settingDetail.isShowButAtRightCorner {
                butAtRightCorner.isHidden = false
            } else {
                butAtRightCorner.isHidden = true
            }
            
            lblTitle.textAlignment = settingDetail.titleAligment
        }
    }
}
