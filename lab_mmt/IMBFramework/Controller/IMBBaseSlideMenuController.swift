//
//  IMBBaseSlideMenuController.swift
//  appMapBoxSwiftTemp
//
//  Created by Tai Duong on 1/17/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import UIKit

class IMBBaseSlideMenuController: IMBBaseViewController
{
    var isShowing = false
    
    var rightAnchorOfSlideMenu: NSLayoutConstraint!
    
    let slideMenu: UIView = {
        let temp = UIView()
        temp.backgroundColor = .white
        temp.addShadow(color: .lightGray, radius: 10)
        return temp
    }()
    
    let contentView: UIView = {
        let temp = UIView()
        temp.backgroundColor = .white
        return temp
    }()
    
    override func setUpSubviews() {
        super.setUpSubviews()
        setUpContentView()
        setUpSlideMenu()
        
    }
    
    override func addSubviews() {
        view.addSubview(contentView)
        view.addSubview(slideMenu)
        
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(handleShowOutSlideMenuForGesture(sender:)))
        rightSwipeGestureRecognizer.direction = .right
        view.addGestureRecognizer(rightSwipeGestureRecognizer)
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(handleHideSlideMenuForGesture(sender:)))
        leftSwipeGestureRecognizer.direction = .left
        view.addGestureRecognizer(leftSwipeGestureRecognizer)
    }
    override func setUpLayout() {
        view.addSameConstraintsWith(format: "V:|[v0]|", for: contentView, slideMenu)
        view.addConstraintsWith(format: "H:|[v0]|", views: contentView)
        
        slideMenu.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        rightAnchorOfSlideMenu = slideMenu.rightAnchor.constraint(equalTo: view.leftAnchor, constant: -10)
        rightAnchorOfSlideMenu.isActive = true
    
    }
    var animateDuration = 0.5
    func handleShowOrHideSlideMenu() {
        if isShowing {
            isShowing = false
            UIView.animate(withDuration: animateDuration, animations: {
                self.slideMenu.layer.transform = CATransform3DIdentity
            })
        } else {
            isShowing = true
            UIView.animate(withDuration: animateDuration, animations: {
                self.slideMenu.layer.transform = CATransform3DTranslate(CATransform3DIdentity, self.view.frame.size.width*0.8 + 10, 0, 0)
            })
        }
    }
    
    func handleShowOutSlideMenu()
    {
        //print("check")
        if !isShowing {
            isShowing = true
            UIView.animate(withDuration: animateDuration, animations: {
                self.slideMenu.layer.transform = CATransform3DTranslate(CATransform3DIdentity, self.view.frame.size.width*0.8 + 10, 0, 0)
            })
        }
    }
    
    @objc func handleShowOutSlideMenuForGesture(sender: UISwipeGestureRecognizer?)
    {
        handleShowOutSlideMenu()
    }
    
    
    func handleHideSlideMenu()
    {
        if isShowing {
            isShowing = false
            UIView.animate(withDuration: animateDuration, animations: {
                self.slideMenu.layer.transform = CATransform3DIdentity
            })
        }
       
    }
    
    @objc func handleHideSlideMenuForGesture(sender: UISwipeGestureRecognizer)
    {
        handleHideSlideMenu()
    }
    
    func setUpSlideMenu()
    {
        
    }
    
    func setUpContentView()
    {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        slideMenu.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        slideMenu.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slideMenu.isHidden = false
    }

}
