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
    let partner: User
    var name: String
    var messages = [Message]()
    
    init(id: String, partner: User) {
        self.id = id
        self.partner = partner
        self.name = partner.displayName
    }
}
