//
//  IMBBaseSlideMenuScrollViewController.swift
//  appMapBoxSwiftTemp
//
//  Created by Tai Duong on 1/17/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import UIKit

class IMBBaseSlideMenuScrollViewController: IMBBaseSlideMenuController, UIScrollViewDelegate
{
    lazy var scrollView: UIScrollView = {
        let temp = UIScrollView()
        temp.delegate = self
        temp.alwaysBounceVertical = true
        
        temp.backgroundColor = .white
    
        //temp.isUserInteractionEnabled = true
        //temp.delaysContentTouches = false
        //temp.canCancelContentTouches = false
        //temp.isExclusiveTouch = true
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
        super.addSubviews()
        contentView.addSubview(scrollView)
        
    }
    override func setUpLayout() {
        super.setUpLayout()
        //scrollView.frame = CGRect(x: 0, y: 0, width: widthOfScreen, height: heightOfScreen)
        //scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.addConstraintsWith(format: "V:|[v0]|", views: scrollView)
        contentView.addConstraintsWith(format: "H:|[v0]|", views: scrollView)
    }
}
