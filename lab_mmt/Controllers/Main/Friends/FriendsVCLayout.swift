//
//  FriendsVCLayout.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class FriendsVCLayout: BaseViewControllerLayout {
    
    lazy var tableView: UITableView = {
        [unowned self] in
        let temp = FriendTableView()
        return temp
        }()
    
    let headerView = FriendTableHeaderView(frame: CGRect.init(x: 0, y: 0, width: widthOfScreen, height: 40))
    
    
    override func setUpLayout() {
        super.setUpLayout()
        
        let search = UISearchController(searchResultsController: nil)
        //        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = AppString.search
        navigationItem.searchController = search
        
        view.addSubviews(subviews:tableView)
        tableView.makeFullWithSuperView()
        
        tableView.tableHeaderView = headerView
    }
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        navigationItem.title = AppString.friends
        
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
