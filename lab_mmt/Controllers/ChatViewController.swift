//
//  ChatViewController.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/27/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

struct MessageCellVM {
    let avtImageURL: URL?
    let name: String
    let time: String
    let message: String
    var height: CGFloat = -1
    
    mutating func setHeight() {
        height = calculateMessageHeight() + 8 + 20 + 8 + 2
    }
    
    func calculateMessageHeight() -> CGFloat {
        let attributedText = NSAttributedString.init(string: message, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        let width = widthOfScreen - 8 - 40 - 8 - 8
        
        let constraintBox = CGSize(width: width, height: .greatestFiniteMagnitude)
        let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
        
        return rect.size.height >= 20 ? rect.size.height : 20
    }
}

class MessageTableView: UITableView {
    static let CELL_ID = "CELL_ID"
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        indicatorStyle = .white
        separatorStyle = .none
        keyboardDismissMode = .interactive
        backgroundColor = .black
        register(MessageCell.self, forCellReuseIdentifier: MessageTableView.CELL_ID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatViewControllerLayout: BaseViewControllerLayout {
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

class ChatViewController: ChatViewControllerLayout {
    
    var webRTCClient: MyWebRTCClient
    //    var partnerID: UserID
    var room: ChatRoom
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    init(webRTCClient: MyWebRTCClient, room: ChatRoom) {
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
        //tableView.contentInset.bottom = inputMessageBar.heightOfMessageBar
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardObservers()
        
        navigationItem.title = room.name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    func reloadTableDataAfterAppendMessage() {
        tableView.reloadData()
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { (_) in
            self.tableView.scrollToRow(at: IndexPath.init(row: self.messageVMs.count - 1, section: 0), at: .bottom, animated: true)
        }
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
        guard let message = notification.userInfo?[MessageHandler.messageUserInfoKey] as? Message else { return }
        for friend in myFriends {
            if friend.username == message.from {
                switch message.message {
                case .text(let text):
                    var vm = MessageCellVM.init(avtImageURL: URL(string: friend.profilePictureUrl), name: friend.displayName, time: IMBPrettyDateLabel.getStringDate(from: UInt(message.createdTime)), message: text)
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
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
                            imageView.removeFromSuperview()
                        }
                    } else {
                        
                        debugPrint("Can not get image from data")
                    }
                }
                
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
        tableView.reloadData()
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
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

extension ChatViewController: InputMessageBarDelegate {
    func inputMessageBarDidTapButtonEmoji() {
    }
    
    func inputMessageBarDidTapButtonSendMessage() {
        let text = (inputMessageBar.inputContentView.txtVInputMessage.text ?? "")
        inputMessageBar.sendTextMessage()
        
        let messagePayload = MessagePayload.text(text)
        let id = UUID().uuidString
        let createdTime = Int64(Date().timeIntervalSince1970)
        
        let message = Message.init(id: id, from: UserProfile.this.username, to: room.partner.username, createdTime: createdTime, message: messagePayload)
        print(message)
        do {
            let dataMessage = try self.encoder.encode(message)
            webRTCClient.sendData(toUserID: room.partner.username, dataMessage)
            
            let dateStr = IMBPrettyDateLabel.getStringDate(from: UInt(createdTime))
            
            var messageVM = MessageCellVM.init(avtImageURL: URL(string: UserProfile.this.profilePictureUrl), name: UserProfile.this.displayName, time: dateStr, message: text)
            messageVM.setHeight()
            
            messageVMs.append(messageVM)
        }
        catch {
            debugPrint("Warning: Could not encode message: \(error)")
        }
        
        reloadTableDataAfterAppendMessage()
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
            do {
                let dataMessage = try self.encoder.encode(message)
                webRTCClient.sendData(toUserID: room.partner.username, dataMessage)
                
            }
            catch {
                debugPrint("Warning: Could not encode message: \(error)")
            }
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
