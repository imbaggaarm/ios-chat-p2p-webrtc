//
//  IMBToolBarBasePopUpViewController.swift
//  AppQuanLiNhaTro
//
//  Created by Tai Duong on 1/31/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import UIKit

//class IMBToolbarBasePopUpViewController: IMBBasePopUpViewController
//{
//    var arrToolbarBottomItems = [UIBarButtonItem]()
//    let vTitle: UIView = {
//        let temp = UIView()
//        temp.backgroundColor = UIColor.init(hexString: "#65c3ba")
//        temp.clipsToBounds = true
//        return temp
//    }()
//    
//    let toolbarBottom: UIToolbar = {
//        let temp = UIToolbar()
//        temp.barTintColor = UIColor.init(hexString: "#65c3ba")
//        temp.tintColor = .white
//        temp.isTranslucent = false
//        //temp.setBackgroundImage(nil, forToolbarPosition: .top, barMetrics: .default)
//        //temp.setShadowImage(nil, forToolbarPosition: .top)
//        temp.clipsToBounds = true
//        return temp
//    }()
//    
//    override func setUpSubviews() {
//        super.setUpSubviews()
//       
//        setUpVInput()
//        setUpToolbarBottom()
//    }
//    
//    override func setUpVInput()
//    {
//        super.setUpVInput()
//        vInput.addSubviews(subviews: vTitle, toolbarBottom)
//        
//        vInput.addConstraintsWith(format: "V:|[v0]", views: vTitle)
//        vTitle.heightAnchor.constraint(equalTo: toolbarBottom.heightAnchor, multiplier: 1).isActive = true
//        vInput.addConstraintsWith(format: "V:[v0]|", views: toolbarBottom)
//        vInput.addSameConstraintsWith(format: "H:|[v0]|", for: vTitle, toolbarBottom)
//    }
//    
//    func setUpToolbarBottom()
//    {
//        
//    }
//
//}
