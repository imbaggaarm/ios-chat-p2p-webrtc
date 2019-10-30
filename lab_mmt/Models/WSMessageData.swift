//
//  WSMessageData.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation

//enum WSMessageDataType: String, Codable {
//    case fromID = "from_id"
//    case toID = "to_id"
//    case username = "username"
//    case candidate = "candidate"
//    case offer = "offer"
//    case answer = "answer"
//}

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
        case success
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
        case candidate
        case fromID = "from_id"
        case toID = "to_id"
    }
}
