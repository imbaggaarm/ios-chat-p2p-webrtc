//
//  ChatDetailNavTitleView.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit
class ChatDetailNavTitleView: UIView {
    
//    let backButton: UIButton = {
//       let temp = UIButton()
//        temp.setImage(AppIcon.navBackIcon, for: .normal)
//        return temp
//    }()
    
    let vImage: UIImageView = {
        let temp = UIImageView()
        temp.backgroundColor = .white
        temp.clipsToBounds = true
        return temp
    }()
    
    let lblName: UILabel = {
        let temp = UILabel()
        temp.font = UIFont.boldSystemFont(ofSize: 17)
        temp.textAlignment = .left
        return temp
    }()
    
    let vOnlineState: UIView = {
        let temp = UIView()
        temp.backgroundColor = .gray
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print(frame)
        
        addSubviews(subviews: vImage, lblName, vOnlineState)
        addConstraintsWith(format: "H:|[v0]-10-[v1]|", views: vImage, lblName)
        addConstraintsWith(format: "V:|[v0]|", views: vImage)
        addConstraintsWith(format: "V:|[v0]|", views: lblName)
        
//        backButton.centerYAnchor(with: self)
//        backButton.makeSquare(size: 25)
        
        vImage.makeCircle(corner: 15)
        vOnlineState.makeCircle(corner: 4)
        
        let spacing = CGFloat(2.0.squareRoot()/2 + 1)*15 - 4
        vOnlineState.leftAnchor(equalTo: vImage.leftAnchor, constant: spacing)
        vOnlineState.topAnchor(equalTo: vImage.topAnchor, constant: spacing)
    }
    
    func setOnlineState(state: P2POnlineState) {
        var color: UIColor
        switch state {
        case .online:
            color = .green
        case .offline:
            color = .gray
        case .doNotDisturb:
            color = .red
        default:
            color = .yellow
        }
        vOnlineState.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
