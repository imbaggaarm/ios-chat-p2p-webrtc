//
//  WSMessage.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation

enum WSMessageType: String, Codable {
    case offer = "OFFER"
    case offerResponse = "OFFER_RESPONSE"
    case answer = "ANSWER"
    case candidate = "CANDIDATE"
    case onlineStateChange = "ONLINE_STATE_CHANGE"
}

enum WSMessage {
    case offer(OfferData)
    case offerRespone(OfferResponse)
    case answer(AnswerData)
    case candidate(CandidateData)
    case onlineState(OnlineStateData)
}

extension WSMessage: Codable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(WSMessageType.self, forKey: .type)
        switch type {
        case .offer:
            self = .offer(try container.decode(OfferData.self, forKey: .data))
        case .offerResponse:
            self = .offerRespone(try container.decode(OfferResponse.self, forKey: .data))
        case .answer:
            self = .answer(try container.decode(AnswerData.self, forKey: .data))
        case .candidate:
            self = .candidate(try container.decode(CandidateData.self, forKey: .data))
        case .onlineStateChange:
            self = .onlineState(try container.decode(OnlineStateData.self, forKey: .data))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .offer(let offerData):
            try container.encode(offerData, forKey: .data)
            try container.encode(WSMessageType.offer, forKey: .type)
        case .answer(let answerData):
            try container.encode(answerData, forKey: .data)
            try container.encode(WSMessageType.answer, forKey: .type)
        case .candidate(let candidateData):
            try container.encode(candidateData, forKey: .data)
            try container.encode(WSMessageType.candidate, forKey: .type)
        case .onlineState(let onlineStateData):
            try container.encode(onlineStateData, forKey: .data)
            try container.encode(WSMessageType.onlineStateChange, forKey: .type)
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
