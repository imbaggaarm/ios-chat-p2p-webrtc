//
//  ChatThreadCellVM.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
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
    let onlineState: P2POnlineState
    let room: ChatRoom
    
    init(with room: ChatRoom) {
        self.room = room
        
        avtImageURL = URL.init(string: room.partner.profilePictureUrl)
        title = room.partner.displayName
        let lastMessage = room.lastMessage
        messageStatusIcon = nil //AppIcon.newMessage
        time = IMBPrettyDateLabel.getStringDate(from: UInt(lastMessage.createdTime))
        lastMessageFont = UIFont.systemFont(ofSize: 14)
        lastMessageTextColor = .white
        
        switch lastMessage.message {
        case .text(let text):
            if UserProfile.this.username == lastMessage.from {
                self.lastMessage = text
            } else {
                self.lastMessage = room.partner.displayName + ": \(text)"
            }
        case .attachment(let attachment):
            var attType = ""
            switch attachment.type {
            case .image:
                attType = "ảnh"
            case .fastEmoji:
                attType = "emoji"
            case .video:
                attType = "video"
            case .file:
                attType = "file"
            default:
                break
            }
            if UserProfile.this.username == lastMessage.from {
                self.lastMessage = "Bạn đã gửi một \(attType)."
            } else {
                self.lastMessage = room.partner.displayName + " đã gửi một \(attType)."
            }
        }
        
        onlineState = room.partner.p2pState
    }
}
