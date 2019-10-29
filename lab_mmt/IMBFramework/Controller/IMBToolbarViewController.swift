//
//  IMBToolbarViewController.swift
//  AppQuanLiNhaTro
//
//  Created by Tai Duong on 2/2/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import UIKit

class IMBToolbarViewController: IMBBaseViewController {
    
    let bottomToolbar: UIToolbar = {
        let temp = UIToolbar()
        temp.barTintColor = UIColor.init(hexString: "#65c3ba")
        temp.tintColor = .white
        temp.isTranslucent = false
        //temp.setBackgroundImage(nil, forToolbarPosition: .top, barMetrics: .default)
        return temp
    }()
    
    func setUpBottomToolbar() {
        
    }
    
    
    override func setUpSubviews() {
        super.setUpSubviews()
        setUpBottomToolbar()
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubviews(subviews: bottomToolbar)
        
    }
    override func setUpLayout() {
        super.setUpLayout()
        view.addConstraintsWith(format: "H:|[v0]|", views: bottomToolbar)
        view.addConstraintsWith(format: "V:[v0]|", views: bottomToolbar)
    }
    
}
