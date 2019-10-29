//
//  IMBBaseCollectionViewCell.swift
//  appMapBoxSwiftTemp
//
//  Created by Tai Duong on 1/18/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import UIKit

class IMBBaseCollectionViewCell: UICollectionViewCell
{

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLayout() {
        
    }

}
