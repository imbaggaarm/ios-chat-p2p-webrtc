//
//  ChatRoom.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/29/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation

class ChatRoom {
    let id: String
    let partner: UserProfile
    var name: String
    var messages = [Message]()
    var lastMessage: Message
    
    init(id: String, partner: UserProfile) {
        self.id = id
        self.partner = partner
        self.name = partner.displayName
        self.lastMessage = Message.init(id: "0", from: partner.username, to: UserProfile.this.username, createdTime: Int64(Date().timeIntervalSince1970), message: MessagePayload.text("Bấm để chat với \(partner.displayName)"))
    }
    
    func addMessage(message: Message) {
        messages.append(message)
        lastMessage = message
    }
}
