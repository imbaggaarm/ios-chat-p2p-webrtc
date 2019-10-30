//
//  FriendCellVM.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

struct FriendCellVM {
    let imageURL: URL?
    let name: String
    let onlineStateColor: UIColor
    
    init(imageURL: URL?, name: String, onlineState: OnlineState) {
        self.imageURL = imageURL
        self.name = name
        switch onlineState {
        case .online:
            onlineStateColor = .green
        case .doNotDisturb:
            onlineStateColor = .red
        default: //offline
            onlineStateColor = .gray
        }
    }
}
