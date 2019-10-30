//
//  ChatVCLayout.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class ChatVCLayout: BaseViewControllerLayout {
    lazy var tableView: MessageTableView = {
        let temp = MessageTableView()
        return temp
    }()
    
    lazy var inputMessageBar: IMBInputMessageBar = {
        let temp = IMBInputMessageBar()
        return temp
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputMessageBar
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func setUpLayout() {
        super.setUpLayout()
        
        view.backgroundColor = .black
        
        view.addSubviews(subviews: tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.makeFullWithSuperView()
        
        tableView.contentInset.bottom = inputMessageBar.heightOfMessageBar
        tableView.scrollIndicatorInsets.bottom = inputMessageBar.heightOfMessageBar
    }
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        
        navigationItem.largeTitleDisplayMode = .never
        
        let audioCallItem = UIBarButtonItem.init(image: AppIcon.audioCall, style: .done, target: self, action: nil)
        let videoCallItem = UIBarButtonItem.init(image: AppIcon.videoCall, style: .done, target: self, action: nil)
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = -20
        
        navigationItem.rightBarButtonItems = [videoCallItem, space, audioCallItem]
    }
    
}
