//
//  FriendsViewController.swift
//  unichat
//
//  Created by Imbaggaarm on 10/13/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

struct FriendCellVM {
    let imageURL: URL?
    let name: String
    let onlineStateColor: UIColor
    
    init(imageURL: URL?, name: String, onlineState: OnlineState) {
        self.imageURL = imageURL
        self.name = name
        switch onlineState {
        case .online:
            onlineStateColor = .green
        case .doNotDisturb:
            onlineStateColor = .red
        default: //offline
            onlineStateColor = .gray
        }
    }
}

class TotalFriendTableHeaderView: UIView {
    
    let lblTotalFriend: UILabel = {
        let temp = UILabel()
        temp.font = UIFont.boldSystemFont(ofSize: 20)
        return temp
    }()
    
    var totalFriend: Int = -1 {
        didSet {
            lblTotalFriend.text = "\(self.totalFriend)" + AppString.totalFriend
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(subviews: lblTotalFriend)
        
        addConstraintsWith(format: "H:|-16-[v0]", views: lblTotalFriend)
        lblTotalFriend.makeFullHeightWithSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FriendTableView: UITableView {
    
    static let CELL_ID = "CELL_ID"
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = .black
        self.separatorStyle = .none
        
        self.showsVerticalScrollIndicator = false
        
        self.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableView.CELL_ID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FriendsViewControllerLayout: BaseViewControllerLayout {
    
    lazy var tableView: UITableView = {
        [unowned self] in
        let temp = FriendTableView()
        return temp
        }()
    
    let headerView = TotalFriendTableHeaderView(frame: CGRect.init(x: 0, y: 0, width: widthOfScreen, height: 40))
    
    
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

class FriendsViewController: FriendsViewControllerLayout, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
        
        addConnectionStateChangeObserver()
    }
    
    override func onLeftBarButtonTapped() {
        super.onLeftBarButtonTapped()
        showUserProfileVC(user: UserProfile.this)
    }
    
    func showUserProfileVC(user: UserProfile) {
        let profileVC = ProfileVC.init(user: user)
        let naVC = UINavigationController.init(rootViewController: profileVC)
        naVC.view.backgroundColor = AppColor.backgroundColor
        present(naVC, animated: true, completion: nil)
    }

    
    deinit {
        removeConnectionStateObserver()
    }
    
    func addConnectionStateChangeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(onConnectionStateChange), name: MessageHandler.onPeerConnectionChanging, object: nil)
    }
    
    func removeConnectionStateObserver() {
        NotificationCenter.default.removeObserver(self, name: MessageHandler.onPeerConnectionChanging, object: nil)
    }
    
    @objc func onConnectionStateChange() {
        loadData()
        tableView.reloadData()
    }
    
    var friendVMs = [FriendCellVM]()
    
    func loadData() {
        friendVMs = []
        for friend in myFriends {
            let vm = FriendCellVM.init(imageURL: URL(string: friend.profilePictureUrl), name: friend.displayName, onlineState: friend.state)
            friendVMs.append(vm)
        }
        
        //        let ive = FriendCellVM(imageURL: UIImage.init(named: "ive"), name: "Jony Ive", onlineState: .doNotDisturb)
        //        let cragh = FriendCellVM(imageURL: UIImage.init(named: "craig"), name: "Craig Federighi", onlineState: .offline)
        //
        //        friendVMs.append(elements: tim, ive, cragh)
        
        tableView.reloadData()
        
        headerView.totalFriend = 3
        
    }
    
}

//MARK: - TABLEVIEW DELEGATE
extension FriendsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendVMs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableView.CELL_ID, for: indexPath) as! FriendTableViewCell
        
        cell.cellVM = friendVMs[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let mainTabbarController = tabBarController as? MainTabBarController {
            let chatVC = ChatViewController(webRTCClient: mainTabbarController.webRTCClient, room: chatRooms[indexPath.row])
            chatVC.hidesBottomBarWhenPushed = true
            show(chatVC, sender: nil)
        }
    }
    
}
