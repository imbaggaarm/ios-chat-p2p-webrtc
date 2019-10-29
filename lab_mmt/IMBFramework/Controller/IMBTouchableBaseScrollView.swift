//
//  IMBTouchableBaseScrollView.swift
//  appMapBoxSwiftTemp
//
//  Created by Tai Duong on 1/17/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import UIKit

class IMBTouchableBaseScrollView: UIScrollView
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delaysContentTouches = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view.isKind(of: UIButton.self)
        {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}
