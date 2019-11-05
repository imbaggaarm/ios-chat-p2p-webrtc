//
//  ChatListTableView.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class ChatListTableView: UITableView {
    static let CELL_ID = "CELL_ID"
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        backgroundColor = .black
        register(ChatThreadTableViewCell.self, forCellReuseIdentifier: ChatListTableView.CELL_ID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

