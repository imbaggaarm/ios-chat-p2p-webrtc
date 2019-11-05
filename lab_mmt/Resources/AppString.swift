//
//  AppString.swift
//  unichat
//
//  Created by Imbaggaarm on 10/14/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation

class AppString {
    static var friends: String {
        return "kFRIENDS".localized()
    }
    
    static var chat: String {
        return "kCHAT".localized()
    }
    
    static var explorer: String {
        return "kEXPLORER".localized()
    }
    
    static var search: String {
        return "kSEARCH".localized()
    }
    
    static var totalFriend: String {
        return "kTOTAL_FRIENDS".localized()
    }
    
    static var profile: String {
        return "kPROFILE_PAGE".localized()
    }
    
    static var register: String {
        return "kREGISTER".localized()
    }
    
    static var login: String {
        return "kLOGIN".localized()
    }
    
    static let settingsVCChangePasswordTxt = "Thay đổi mật khẩu"
    static let settingsVCPrivacyPolicyTxt = "Chính sách quyền riêng tư"
    static let settingsVCTermsOfUseTxt = "Điều khoản sử dụng"
    static let settingsVCRulesTxt = "Nội quy"
    static let settingsVCAppInfoTxt = "Thông tin ứng dụng"
    static let settingsVCSupportTxt = "Hỗ trợ & Thông báo lỗi"
    static let settingsVCLogoutTxt = "Đăng xuất"
    
    static let settingVCTitle = "Cài đặt"
    static let detailSettingPasswordVCTitle = "Mật khẩu"
    static let detailSettingPrivacyPolicyVCTitle = "Chính sách quyền riêng tư"
    static let detailSettingTermsOfUseVCTitle = "Điều khoản sử dụng"
    static let detailSettingRulesVCTitle = "Nội quy"
    static let detailSettingAppInfoVCTitle = "Thông tin ứng dụng"
    static let detailSettingSupportVCTitle = "Hỗ trợ & thông báo lỗi"
    
    static let supportEmail = "contact.bkschedule@gmail.com"
    
    static let contactEmail = "contact.bkschedule@gmail.com"
    static let reportBugEmail = "reportbug.bkschedule@gmail.com"
    
    static let termsURL = "https://bkuschedule.web.app/terms.html"
    static let policyURL = "https://bkuschedule.web.app/policy.html"
    
    static var appVersion: String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return "v\(version)"
    }
    
    static var bundleShortVersionString: String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return version
    }
}
