//
//  ChatListVCLayout.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class ChatListVCLayout: BaseViewControllerLayout {
    
    lazy var tableView: ChatListTableView = {
        let temp = ChatListTableView()
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setUpLayout() {
        super.setUpLayout()
        
        let search = UISearchController(searchResultsController: nil)
        //        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = AppString.search
        navigationItem.searchController = search
        
        view.addSubviews(subviews: tableView)
        tableView.makeFullWithSuperView()
    }
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        
        //        let leftBarButton = UIBarButtonItem.init(image: AppIcon.navbarAvt, style: .done, target: nil, action: nil)
        //        navigationItem.leftBarButtonItem = leftBarButton
//        
//        let rightBarButton = UIBarButtonItem.init(image: AppIcon.navNewChatThread, style: .done, target: nil, action: nil)
//        navigationItem.rightBarButtonItem = rightBarButton
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        navigationItem.title = AppString.chat
        
        let logoImageView = UIImageView()
        logoImageView.clipsToBounds = true
        logoImageView.kf.setImage(with: URL.init(string: UserProfile.this.profilePictureUrl))
        logoImageView.frame = CGRect(x:0.0,y:0.0, width:32, height:32)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(onLeftBarButtonTapped))
        logoImageView.addGestureRecognizer(tapGesture)
        
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        logoImageView.makeCircle(corner: 16)
        navigationItem.leftBarButtonItem =  imageItem
        
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
    }
    
    @objc func onLeftBarButtonTapped() {
        
    }
}
