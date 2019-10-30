//
//  MessageTableView.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class MessageTableView: UITableView {
    static let CELL_ID = "CELL_ID"
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        indicatorStyle = .white
        separatorStyle = .none
        keyboardDismissMode = .interactive
        backgroundColor = .black
        register(MessageCell.self, forCellReuseIdentifier: MessageTableView.CELL_ID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

