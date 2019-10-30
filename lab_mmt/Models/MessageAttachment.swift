//
//  MessageAttachment.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation

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
