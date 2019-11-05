//
//  MessagePayload.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation

enum MessagePayloadType: String, Codable {
    case text = "text"
    case attachment = "attachment"
}

enum MessagePayload {
    case text(String)
    case attachment(Attachment)
}

extension MessagePayload: Codable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(MessagePayloadType.self, forKey: .type)
        switch type {
        case .text:
            self = .text(try container.decode(String.self, forKey: .text))
        case .attachment:
            self = .attachment(try container.decode(Attachment.self, forKey: .attachment))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let text):
            try container.encode(text, forKey: .text)
            try container.encode(MessagePayloadType.text, forKey: .type)
        case .attachment(let attachment):
            try container.encode(attachment, forKey: .attachment)
            try container.encode(MessagePayloadType.attachment, forKey: .type)
        }
    }
    
    enum DecodeError: Error {
        case unknownType
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case text
        case attachment
    }
}


