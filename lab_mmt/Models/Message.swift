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
        case message = "message"
    }
}

enum AttachmentType: String, Codable {
    case image
    case audio
    case video
    case file
}

struct Attachment: Codable {
    let type: AttachmentType
    let payload: Data
    
    
}


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
        case type, text, attachment
    }

}

enum MessageType: String, Codable {
    case login = "LOGIN"
    case offer = "OFFER"
    case offerResponse = "OFFER_RESPONSE"
    case answer = "ANSWER"
    case candidate = "CANDIDATE"
    case leave = "LEAVE"
}

enum MessageDataType: String, Codable {
    case fromID = "from_id"
    case toID = "to_id"
    case username = "username"
    case candidate = "candidate"
    case offer = "offer"
    case answer = "answer"
}

public struct LoginData: Codable {
    let username: String
    
}

public struct OfferData: Codable {
    let sdp: SessionDescription
    let fromID: String
    let toID: String
    
    enum CodingKeys: String, CodingKey {
        case sdp = "offer"
        case fromID = "from_id"
        case toID = "to_id"
    }
}

public struct OfferResponse: Codable {
    let fromID: String
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case fromID = "from_id"
        case success // = "success"
    }
}

public struct AnswerData: Codable {
    let sdp: SessionDescription
    let fromID: String
    let toID: String
    
    enum CodingKeys: String, CodingKey {
        case sdp = "answer"
        case fromID = "from_id"
        case toID = "to_id"
    }
}

public struct CandidateData: Codable {
    let candidate: IceCandidate
    let fromID: String
    let toID: String
    
    enum CodingKeys: String, CodingKey {
        case candidate = "candidate"
        case fromID = "from_id"
        case toID = "to_id"
    }
}

enum MyMessage {
    case login(LoginData)
    case offer(OfferData)
    case offerRespone(OfferResponse)
    case answer(AnswerData)
    case candidate(CandidateData)
}

extension MyMessage: Codable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(MessageType.self, forKey: .type)
        switch type {
        case .login:
            self = .login(try container.decode(LoginData.self, forKey: .data))
        case .offer:
            self = .offer(try container.decode(OfferData.self, forKey: .data))
        case .offerResponse:
            self = .offerRespone(try container.decode(OfferResponse.self, forKey: .data))
        case .answer:
            self = .answer(try container.decode(AnswerData.self, forKey: .data))
        case .candidate:
            self = .candidate(try container.decode(CandidateData.self, forKey: .data))
        default:
            throw DecodeError.unknownType
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .login(let loginData):
            try container.encode(loginData, forKey: .data)
            try container.encode(MessageType.login, forKey: .type)
        case .offer(let offerData):
            try container.encode(offerData, forKey: .data)
            try container.encode(MessageType.offer, forKey: .type)
        case .answer(let answerData):
            try container.encode(answerData, forKey: .data)
            try container.encode(MessageType.answer, forKey: .type)
        case .candidate(let candidateData):
            try container.encode(candidateData, forKey: .data)
            try container.encode(MessageType.candidate, forKey: .type)
        default:
            print("DOES NOT HAVE NOW")
        }
    }
    enum DecodeError: Error {
        case unknownType
    }
    
    enum CodingKeys: String, CodingKey {
        case type, data
    }

}
