//
//  ChatListViewController.swift
//  unichat
//
//  Created by Imbaggaarm on 10/13/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

struct ChatThreadCellVM {
    let avtImageURL: URL?
    let title: String
    let lastMessage: String
    let messageStatusIcon: UIImage?
    let time: String
    let lastMessageFont: UIFont
    let lastMessageTextColor: UIColor
}

class ChatListTableView: UITableView {
    static let CELL_ID = "CELL_ID"
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        backgroundColor = .black
        register(ChatThreadTableViewCell.self, forCellReuseIdentifier: ChatListTableView.CELL_ID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class ChatListViewControllerLayout: BaseViewControllerLayout {
    
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
        
        
        let rightBarButton = UIBarButtonItem.init(image: AppIcon.navNewChatThread, style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem = rightBarButton
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        navigationItem.title = AppString.chat
        
        let logoImageView = UIImageView()
        logoImageView.clipsToBounds = true
        logoImageView.kf.setImage(with: URL.init(string: User.this.avtStrURL))
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

//
class ChatListViewController: ChatListViewControllerLayout, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
    }
    
    var chatThreadVMs = [ChatThreadCellVM]()
    var chatRooms = [ChatRoom]()
    
    func loadData() {
        
        for friend in friends {
            let room = ChatRoom.init(id: friend.username, partner: friend)
            let thread = ChatThreadCellVM(avtImageURL: URL(string: friend.avtStrURL), title: friend.displayName, lastMessage: "Last message", messageStatusIcon: AppIcon.newMessage, time: "13:02", lastMessageFont: UIFont.boldSystemFont(ofSize: 14), lastMessageTextColor: .white)
            chatRooms.append(room)
            chatThreadVMs.append(thread)
        }
//        let thread = ChatThreadCellVM(avtImageURL: AppIcon.timAvt, title: "Tim Cook", lastMessage: "Hello, how are you? Long time no see", messageStatusIcon: AppIcon.newMessage, time: "13:02", lastMessageFont: UIFont.boldSystemFont(ofSize: 14), lastMessageTextColor: .white)
//        let thread1 = ChatThreadCellVM(avtImageURL: AppIcon.iveAvt, title: "Jony Ive", lastMessage: "Bạn: Why the hell did you leave Apple? Did Tim Cook bully you? Tell me if that happend", messageStatusIcon: AppIcon.sentMessage, time: "Hôm qua, 23:05", lastMessageFont: UIFont.systemFont(ofSize: 14), lastMessageTextColor: .gray)
//        let thread2 = ChatThreadCellVM(avtImageURL: AppIcon.craigAvt, title: "Craig Federighi", lastMessage: "Tai, Can you join Apple?", messageStatusIcon: AppIcon.newMessage, time: "Hôm qua, 22:35", lastMessageFont: UIFont.boldSystemFont(ofSize: 14), lastMessageTextColor: .white)
    
//        chatThreadVMs.append(elements: thread, thread1, thread2)
        tableView.reloadData()
    }
    
    override func onLeftBarButtonTapped() {
        super.onLeftBarButtonTapped()
        let profileVC = ProfileVC.init(user: User.this)
        let naVC = UINavigationController.init(rootViewController: profileVC)
        naVC.view.backgroundColor = AppColor.backgroundColor
        present(naVC, animated: true, completion: nil)
    }
}


//MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension ChatListViewController {
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
        
        if let mainTabbarController = tabBarController as? MainTabBarController {
            let username = friends[0].username
//            let text = "Hello, I'm: " + username
//            print(text)
//            mainTabbarController.webRTCClient.sendData(toUserID: username, text.data(using: .utf8)!)
            
            let chatVC = ChatViewController(webRTCClient: mainTabbarController.webRTCClient, room: chatRooms[indexPath.row])
            chatVC.hidesBottomBarWhenPushed = true
            show(chatVC, sender: nil)
        }
        
        
    }
}
