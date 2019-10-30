//
//  FriendTableView.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class FriendTableHeaderView: UIView {
    
    let lblTotalFriend: UILabel = {
        let temp = UILabel()
        temp.font = UIFont.boldSystemFont(ofSize: 20)
        return temp
    }()
    
    var totalFriend: Int = -1 {
        didSet {
            lblTotalFriend.text = "\(self.totalFriend)" + AppString.totalFriend
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(subviews: lblTotalFriend)
        
        addConstraintsWith(format: "H:|-16-[v0]", views: lblTotalFriend)
        lblTotalFriend.makeFullHeightWithSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class FriendTableView: UITableView {
    
    static let CELL_ID = "CELL_ID"
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = .black
        self.separatorStyle = .none
        
        self.showsVerticalScrollIndicator = false
        
        self.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableView.CELL_ID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
