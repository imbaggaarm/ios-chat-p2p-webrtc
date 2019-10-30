//
//  ChatListVC.swift
//  unichat
//
//  Created by Imbaggaarm on 10/13/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

var chatRooms = [ChatRoom]()

class ChatListVC: ChatListVCLayout, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
     
        addOnNewMessageObserver()
        loadData()
    }
    
    var chatThreadVMs = [ChatThreadCellVM]()
    
    func loadData() {
        for friend in myFriends {
            let room = ChatRoom.init(id: friend.username, partner: friend)
            let thread = ChatThreadCellVM.init(with: room)
            chatThreadVMs.append(thread)
            chatRooms.append(room)
        }
        tableView.reloadData()
    }
    
    func reloadData() {
        chatThreadVMs = []
        for room in chatRooms {
            let thread = ChatThreadCellVM.init(with: room)
            chatThreadVMs.append(thread)
        }
        tableView.reloadData()
    }
    override func onLeftBarButtonTapped() {
        super.onLeftBarButtonTapped()
        let profileVC = ProfileVC.init(user: UserProfile.this)
        let naVC = UINavigationController.init(rootViewController: profileVC)
        naVC.view.backgroundColor = AppColor.backgroundColor
        present(naVC, animated: true, completion: nil)
    }
    
    func addOnNewMessageObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleNewMessage(notification:)), name: MessageHandler.onNewMessage, object: nil)
    }
    
    func removeOnNewMessageObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        removeOnNewMessageObserver()
    }
    
    @objc func handleNewMessage(notification: Notification) {
//        guard let message = notification.userInfo?[MessageHandler.messageUserInfoKey] as? Message else { return }
        reloadData()
    }
    
}


//MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension ChatListVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatThreadVMs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTableView.CELL_ID, for: indexPath) as! ChatThreadTableViewCell
        cell.cellVM = chatThreadVMs[indexPath.row]
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
