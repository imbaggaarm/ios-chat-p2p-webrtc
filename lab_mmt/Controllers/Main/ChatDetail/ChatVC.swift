//
//  ChatVC.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/27/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class ChatVC: ChatVCLayout {
    
    var webRTCClient: WebRTCClient
    //    var partnerID: UserID
    var room: ChatRoom
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    init(webRTCClient: WebRTCClient, room: ChatRoom) {
        self.webRTCClient = webRTCClient
        self.room = room
        super.init(nibName: nil, bundle: nil)
        
        addOnNewMessageObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        inputMessageBar.delegate = self
        loadData()
        
        navTitleView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(onNavTitleViewTapped))
        navTitleView.addGestureRecognizer(tapGesture)
        
        navTitleView.lblName.text = room.name
        navTitleView.setOnlineState(state: room.partner.p2pState)
        navTitleView.vImage.kf.setImage(with: URL.init(string: room.partner.profilePictureUrl)!)
        
        //        navTitleView.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    @objc func onNavTitleViewTapped() {
        let profileVC = ProfileVC.init(user: room.partner)
        present(profileVC, animated: true, completion: nil)
    }
    
    var isFirstLoad = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLoad {
            isFirstLoad = false
            if messageVMs.count != 0 {
                self.tableView.scrollToRow(at: IndexPath.init(row: self.messageVMs.count - 1, section: 0), at: .middle, animated: false)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    func reloadTableDataAfterAppendMessage() {
        tableView.reloadData()
        if messageVMs.count != 0 {
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { (_) in
                self.tableView.scrollToRow(at: IndexPath.init(row: self.messageVMs.count - 1, section: 0), at: .middle, animated: true)
            }
        }
    }
    
    func addOnNewMessageObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleNewMessage(notification:)), name: MessageHandler.onNewMessage, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleNewOnlineState), name: MessageHandler.onPeerConnectionChanging, object: nil)
    }
    
    func removeOnNewMessageObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        removeOnNewMessageObserver()
    }
    
    
    @objc func handleNewOnlineState() {
        navTitleView.setOnlineState(state: room.partner.p2pState)
    }
    
    @objc func handleNewMessage(notification: Notification) {
        guard let message = notification.userInfo?[MessageHandler.messageUserInfoKey] as? Message else { return }
        if message.from == room.partner.username {
            switch message.message {
            case .text(let text):
                var vm = MessageCellVM.init(avtImageURL: URL(string: room.partner.profilePictureUrl), name: room.partner.displayName, time: IMBPrettyDateLabel.getStringDate(from: UInt(message.createdTime)), message: text)
                vm.setHeight()
                messageVMs.append(vm)
                reloadTableDataAfterAppendMessage()
            case .attachment(let attachment):
                if let image = UIImage.init(data: attachment.payload) {
                    let imageView = UIImageView()
                    imageView.image = image
                    view.addSubview(imageView)
                    imageView.makeCenter(with: view)
                    imageView.width(constant: image.size.width)
                    imageView.height(constant: image.size.height)
                    
                    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                        //
                        imageView.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1)
                    }, completion: { (completed) in
                        UIView.animate(withDuration: 0.3, animations: {
                            imageView.alpha = 0
                        }, completion: { (completed) in
                            imageView.removeFromSuperview()
                        })
                    })
                } else {
                    
                    debugPrint("Can not get image from data")
                }
            }
        } else if message.to == room.partner.username {
            switch message.message {
            case .text(let text):
                var vm = MessageCellVM.init(avtImageURL: URL(string: UserProfile.this.profilePictureUrl), name: UserProfile.this.displayName, time: IMBPrettyDateLabel.getStringDate(from: UInt(message.createdTime)), message: text)
                vm.setHeight()
                messageVMs.append(vm)
                reloadTableDataAfterAppendMessage()
            default:
                break
            }
        }
        
    }
    
    func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    var currentKeyboardHeight: CGFloat = -1
    @objc func keyboardWillChangeFrame(notification: Notification) {
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let nextKeyboardHeight = keyboardEndFrame.height
        tableView.contentInset.bottom = nextKeyboardHeight
        tableView.scrollIndicatorInsets.bottom = nextKeyboardHeight
        
        if currentKeyboardHeight == -1 {
            currentKeyboardHeight = nextKeyboardHeight
            return
        }
        
        let spacing = nextKeyboardHeight - currentKeyboardHeight
        if spacing > 0 {
            let tableViewHeight = tableView.frame.size.height
            let contentHeight = tableView.contentSize.height
            if tableViewHeight - contentHeight < nextKeyboardHeight {
                tableView.contentOffset.y += spacing
            }
        }
        currentKeyboardHeight = nextKeyboardHeight
    }
    
    var messageVMs = [MessageCellVM]()
    func loadData() {
        for message in room.messages {
            if room.partner.username == message.from {
                switch message.message {
                case .text(let text):
                    var vm = MessageCellVM.init(avtImageURL: URL(string: room.partner.profilePictureUrl), name: room.partner.displayName, time: IMBPrettyDateLabel.getStringDate(from: UInt(message.createdTime)), message: text)
                    vm.setHeight()
                    messageVMs.append(vm)
                case .attachment(_):
                    break
                }
            } else if message.to == room.partner.username {
                switch message.message {
                case .text(let text):
                    var vm = MessageCellVM.init(avtImageURL: URL(string: UserProfile.this.profilePictureUrl), name: UserProfile.this.displayName, time: IMBPrettyDateLabel.getStringDate(from: UInt(message.createdTime)), message: text)
                    vm.setHeight()
                    messageVMs.append(vm)
                default:
                    break
                }
            }
        }
    }
    
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageVMs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return messageVMs[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableView.CELL_ID, for: indexPath) as! MessageCell
        cell.cellVM = messageVMs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ChatVC: InputMessageBarDelegate {
    func inputMessageBarDidTapButtonEmoji() {
    }
    
    func sendMessage(message: Message) {
        guard room.partner.p2pState == .online || room.partner.p2pState == .doNotDisturb else {
            letsAlert(withMessage: "\(room.partner.displayName) không online.")
            return
        }
        
        do {
            let dataMessage = try self.encoder.encode(message)
            webRTCClient.sendData(toUserID: room.partner.username, dataMessage)
            room.addMessage(message: message)
            
            let notification = Notification.init(name: MessageHandler.onNewMessage, object: nil, userInfo: [
                MessageHandler.messageUserInfoKey: message
            ])
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(notification)
            }
        }
        catch {
            debugPrint("Warning: Could not encode message: \(error)")
        }
    }
    
    func inputMessageBarDidTapButtonSendMessage() {
        let text = (inputMessageBar.inputContentView.txtVInputMessage.text ?? "")
        inputMessageBar.sendTextMessage()
        
        let messagePayload = MessagePayload.text(text)
        let id = UUID().uuidString
        let createdTime = Int64(Date().timeIntervalSince1970)
        
        let message = Message.init(id: id, from: UserProfile.this.username, to: room.partner.username, createdTime: createdTime, message: messagePayload)
        print(message)
        sendMessage(message: message)
    }
    
    func inputMessageBarDidTapButtonFastEmoji() {
        let image = AppIcon.fastEmojiTest!
        if let data = image.pngData() {
            let attachment = Attachment.init(type: .image, payload: data)
            let messagePayload = MessagePayload.attachment(attachment)
            let id = UUID().uuidString
            let createdTime = Int64(Date().timeIntervalSince1970)
            
            let message = Message.init(id: id, from: UserProfile.this.username, to: room.partner.username, createdTime: createdTime, message: messagePayload)
            
            print(message)
            sendMessage(message: message)
        } else {
            print("can not get data from fast emoji")
        }
    }
    
    func inputMessageBarDidTapButtonPickImage() {
        //
    }
    
    func inputMessageBarDidTapButtonCamera() {
        //
    }
    
    func inputMessageBarTxtVDidBecomeFirstResponder() {
        //
    }
    
    func inputMessageBarTxtVDidResignFirstResponder() {
        //
    }
    
    
}
