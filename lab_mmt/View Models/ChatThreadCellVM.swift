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
    
    init(with room: ChatRoom) {
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
        case .attachment(_):
            if UserProfile.this.username == lastMessage.from {
                self.lastMessage = "Bạn đã gửi một ảnh."
            } else {
                self.lastMessage = room.partner.displayName + " đã gửi một ảnh."
            }
        }
    }
}
