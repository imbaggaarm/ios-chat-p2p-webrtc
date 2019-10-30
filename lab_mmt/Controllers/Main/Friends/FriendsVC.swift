//
//  FriendsVC.swift
//  unichat
//
//  Created by Imbaggaarm on 10/13/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class FriendsVC: FriendsVCLayout, UITableViewDelegate, UITableViewDataSource {
    
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
            let vm = FriendCellVM.init(imageURL: URL(string: friend.profilePictureUrl), name: friend.displayName, onlineState: friend.p2pState)
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
extension FriendsVC {
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
        if let mainTabbarController = tabBarController as? MainTabbarVC {
            let chatVC = ChatVC(webRTCClient: mainTabbarController.webRTCClient, room: chatRooms[indexPath.row])
            chatVC.hidesBottomBarWhenPushed = true
            show(chatVC, sender: nil)
        }
    }
    
}
