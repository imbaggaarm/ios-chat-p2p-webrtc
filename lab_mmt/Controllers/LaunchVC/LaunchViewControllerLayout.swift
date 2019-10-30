//
//  ViewController.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/7/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit

class LaunchViewControllerLayout: BaseViewControllerLayout {
    
    var appVersion: String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return "v\(version)"
    }
    
    let imgVLogo: UIImageView = {
        let temp = UIImageView()
        temp.backgroundColor = .clear
        temp.contentMode = .scaleAspectFit
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.image = AppIcon.appIcon
        return temp
    }()
    
    let lblInfo: UILabel = {
        let temp = UILabel()
        temp.textAlignment = .center
        temp.textColor = .white
        temp.font = UIFont.avenirNext(size: 12, type: .medium)
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        lblInfo.text = appVersion
    }

    override func setUpLayout() {
        super.setUpLayout()
        
        view.addSubviews(subviews: imgVLogo, lblInfo)
        
        //lblInfo
        do {
            lblInfo.bottomAnchor(equalTo: view.bottomAnchor, constant: -25)
            lblInfo.centerXAnchor(with: view)
            lblInfo.height(constant: 20)
        }
        
        //imgVLogo
        do {
            imgVLogo.makeSquare(size: widthOfScreen*1/2)
            imgVLogo.makeCenter(with: view)
        }
    }
}


