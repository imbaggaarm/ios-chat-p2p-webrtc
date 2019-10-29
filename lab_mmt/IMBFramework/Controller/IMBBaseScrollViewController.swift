//
//  IMBBaseScrollViewController.swift
//  appMapBoxSwiftTemp
//
//  Created by Tai Duong on 1/17/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import UIKit

class IMBBaseScrollViewContoller: IMBBaseViewController, UIScrollViewDelegate
{
    lazy var scrollView: UIScrollView = {
        let temp = UIScrollView()
        temp.delegate = self
        temp.alwaysBounceVertical = true
        temp.canCancelContentTouches = true
        temp.backgroundColor = .white
        temp.delaysContentTouches = false
        return temp
    }()
    
    func setUpScrollView()
    {
        
    }
    
    override func setUpSubviews() {
        super.setUpSubviews()
        setUpScrollView()
    }
    
    override func addSubviews() {
        view.addSubview(scrollView)
    }
    override func setUpLayout() {
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

