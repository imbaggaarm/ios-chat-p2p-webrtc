//
//  MessageCellVM.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

struct MessageCellVM {
    let avtImageURL: URL?
    let name: String
    let time: String
    let message: String
    var height: CGFloat = -1
    
    mutating func setHeight() {
        height = calculateMessageHeight() + 8 + 20 + 8 + 2
    }
    
    func calculateMessageHeight() -> CGFloat {
        let attributedText = NSAttributedString.init(string: message, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        let width = widthOfScreen - 8 - 40 - 8 - 8
        
        let constraintBox = CGSize(width: width, height: .greatestFiniteMagnitude)
        let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
        
        return rect.size.height >= 20 ? rect.size.height : 20
    }
}
