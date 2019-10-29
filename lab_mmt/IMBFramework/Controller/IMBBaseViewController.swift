//
//  IMBBaseViewController.swift
//  appMapBoxSwiftTemp
//
//  Created by Tai Duong on 1/13/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import UIKit

class IMBBaseViewController: UIViewController
{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customMySelf()
        addSubviews()
        setUpLayout()
        setUpSubviews()
    }
    
    func setUpSubviews()
    {
        
    }
    func addSubviews()
    {
        
    }
    
    func setUpLayout()
    {
        
    }
    
    func customMySelf()
    {
        view.backgroundColor = .white
    }
    
    func setUpNavigationController()
    {
        
    }
}

class BaseViewControllerLayout: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpNavigationBar()
    }
    
    func setUpLayout() {
        
    }
    
    func setUpNavigationBar() {
        
    }
}
