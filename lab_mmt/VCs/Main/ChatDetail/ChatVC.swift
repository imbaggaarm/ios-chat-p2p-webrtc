//
//  ChatVC.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/27/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit
import AVKit
import AttachmentPicker

class ChatVC: ChatVCLayout {
    
    var webRTCClient: WebRTCClient
    //    var partnerID: UserID
    var room: ChatRoom
    
    let menu = HSAttachmentPicker()
    
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
        
        menu.delegate = self
    }
    
    @objc func onNavTitleViewTapped() {
        let profileNVC = UINavigationController.init(rootViewController: ProfileVC.init(user: room.partner))
        present(profileNVC, animated: true, completion: nil)
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
    
    func presentFileViewer(attachment: Attachment) {
        do {
            let url = try AppUserDefaults.sharedInstance.store(data: attachment.payload, name: attachment.name)
            let fileViewer = FileViewerVCLayout.init(attachment: attachment, url: url)
            present(UINavigationController.init(rootViewController: fileViewer), animated: true, completion: nil)
        } catch {
            print("Error")
        }
    }
    
    func showFastEmoji(attachment: Attachment) {
        if let image = UIImage.init(data: attachment.payload) {
            
            let bgView = UIView()
            
            let imageView = UIImageView()
            imageView.image = image
            
            bgView.addSubviews(subviews: imageView)
            imageView.makeCenter(with: bgView)
            imageView.width(constant: image.size.width)
            imageView.height(constant: image.size.height)
            
            view.addSubview(bgView)
            bgView.makeFullWidthWithSuperView()
            bgView.topAnchor(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
            bgView.height(constant: heightOfScreen - view.safeAreaLayoutGuide.layoutFrame.origin.y - currentKeyboardHeight)
            
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                //
                imageView.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1)
            }, completion: { (completed) in
                UIView.animate(withDuration: 0.3, animations: {
                    imageView.alpha = 0
                }, completion: { (completed) in
                    bgView.removeFromSuperview()
                })
            })
        } else {
            debugPrint("Can not get image from data")
        }
    }
    
    func showImage(attachment: Attachment) {
        if let image = UIImage.init(data: attachment.payload) {
            let imagePreview = ImagePreviewVC(image: image)
            present(UINavigationController.init(rootViewController: imagePreview), animated: true, completion: nil)
        } else {
            debugPrint("Can not get image from data")
        }
    }
    
    func showVideo(attachment: Attachment) {
        do {
            let url = try AppUserDefaults.sharedInstance.store(data: attachment.payload, name: attachment.name)
            let player = AVPlayer(url: url)
            let vc = AVPlayerViewController()
            vc.player = player
            present(vc, animated: true, completion: nil)
        } catch {
            print("Error")
        }
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
                if attachment.currentPackage < attachment.totalPackage {
                    break
                }
                switch attachment.type {
                case .image:
                    showImage(attachment: attachment)
                case .video:
                    showVideo(attachment: attachment)
                case .fastEmoji:
                    showFastEmoji(attachment: attachment)
                case .file:
                    //append new data to old
                    presentFileViewer(attachment: attachment)
                default:
                    break
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
            
            print(dataMessage.prettyPrintedJSONString ?? "")
            
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
            let attachment = Attachment.init(name: "fast_emoji.png", type: .fastEmoji, payload: data, totalPackage: 1, currentPackage: 1)
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
        
    }
    
    func inputMessageBarDidTapButtonCamera() {
        menu.showAttachmentMenu()
    }
    
    func inputMessageBarTxtVDidBecomeFirstResponder() {
        //
    }
    
    func inputMessageBarTxtVDidResignFirstResponder() {
        //
    }
}

extension ChatVC: HSAttachmentPickerDelegate {
    func attachmentPickerMenu(_ menu: HSAttachmentPicker, show controller: UIViewController, completion: (() -> Void)? = nil) {
        self.present(controller, animated: true, completion: completion)
    }
    
    func attachmentPickerMenu(_ menu: HSAttachmentPicker, showErrorMessage errorMessage: String) {
        print(errorMessage)
    }
    
    func attachmentPickerMenu(_ menu: HSAttachmentPicker, upload data: Data, filename: String, image: UIImage?) {
        
        if data.count == 0 {
            letsAlert(withMessage: "Mời bạn chọn lại file. File không thể load để gửi đi.")
            return
        }
        
        let maxSizePerEach = 16*1024
        let totalPackage = Int(Double(data.count)/Double(maxSizePerEach)) + 1
        var attachmentType: AttachmentType
        if filename.isImageType() {
            attachmentType = .image
        } else if filename.isVideoType() {
            attachmentType = .video
        } else {
            attachmentType = .file
        }
        
        
        let id = UUID().uuidString
        let createdTime = Int64(Date().timeIntervalSince1970)
        
        
        for i in 1...totalPackage {
            let min = i*maxSizePerEach - maxSizePerEach
            let splicedData = data[min, min + maxSizePerEach]
            let attachment: Attachment = Attachment.init(name: filename, type: attachmentType, payload: splicedData, totalPackage: totalPackage, currentPackage: i)
            let messagePayload = MessagePayload.attachment(attachment)
            let message = Message.init(id: id, from: UserProfile.this.username, to: room.partner.username, createdTime: createdTime, message: messagePayload)
            sendMessage(message: message)
        }
        
    }
}

extension Data {
    subscript(start:Int?, stop:Int?) -> Data {
        var front = 0
        if let start = start {
            front = start < 0 ? Swift.max(self.count + start, 0) : Swift.min(start, self.count)
        }
        var back = self.count
        if let stop  = stop {
            back = stop < 0 ? Swift.max(self.count + stop, 0) : Swift.min(stop, self.count)
        }
        if front >= back {
            return Data()
        }
        let range = front..<back
        return self.subdata(in: range)
    }
}

extension String {
    public func isImageType() -> Bool {
        // image formats which you want to check
        let imageFormats = ["jpg", "png", "gif", "heic"]
        
        if URL(string: self) != nil  {
            
            let extensi = (self as NSString).pathExtension
            
            return imageFormats.contains(extensi)
        }
        return false
    }
    
    public func isVideoType() -> Bool {
        let formats = ["mov", "mp4"]
        
        if URL(string: self) != nil  {
            
            let extensi = (self as NSString).pathExtension
            
            return formats.contains(extensi)
        }
        return false
    }
    
    public func isAudioType() -> Bool {
        let formats = ["mp3"]
        
        if URL(string: self) != nil  {
            
            let extensi = (self as NSString).pathExtension
            
            return formats.contains(extensi)
        }
        return false
    }
}
