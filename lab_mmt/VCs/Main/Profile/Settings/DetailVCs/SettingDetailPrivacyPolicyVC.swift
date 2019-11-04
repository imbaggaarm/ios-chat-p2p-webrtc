//
//  SettingDetailPrivacyPolicyVC.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/13/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit

class SettingDetailPrivacyPolicyVC: IMBBaseWebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }        
    
        loadWebViewWith(url: URL.init(string: AppString.policyURL)!)
        
        title = AppString.detailSettingPrivacyPolicyVCTitle
    }
    
}
