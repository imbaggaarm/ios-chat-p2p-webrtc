//
//  MessageAttachment.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation

enum AttachmentType: String, Codable {
    case fastEmoji
    case image
    case video
    case file
    
    enum CodingKeys: String, CodingKey {
        case fastEmoji = "fast_emoji"
        case image
        case video
        case file
    }
}

struct Attachment: Codable {
    let name: String
    var type: AttachmentType
    var payload: Data
    var totalPackage: Int
    var currentPackage: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case type
        case payload
        case totalPackage = "total_package"
        case currentPackage = "current_package"
    }
}
