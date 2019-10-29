//
//  IMBBaseTableViewCell.swift
//  appMapBoxSwiftTemp
//
//  Created by Tai Duong on 1/13/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import UIKit

class IMBBaseTableViewCell: UITableViewCell
{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpLayout() {
        
    }
    
    func showData() {
        
    }
}
