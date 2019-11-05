//
//  Message.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/27/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation

//define message object
struct Message: Codable {
    let id: String
    let from: String
    let to: String
    let createdTime: Int64
    let message: MessagePayload
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(from, forKey: .from)
        try container.encode(to, forKey: .to)
        try container.encode(createdTime, forKey: .createdTime)
        try container.encode(message, forKey: .message)
    }
    
    init(id: String, from: String, to: String, createdTime: Int64, message: MessagePayload) {
        self.id = id
        self.from = from
        self.to = to
        self.createdTime = createdTime
        self.message = message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let from = try container.decode(String.self, forKey: .from)
        let to = try container.decode(String.self, forKey: .to)
        let createdTime = try container.decode(Int64.self, forKey: .createdTime)
        let message = try container.decode(MessagePayload.self, forKey: .message)
        self = .init(id: id, from: from, to: to, createdTime: createdTime, message: message)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case from
        case to
        case createdTime = "created_time"
        case message
    }
}


