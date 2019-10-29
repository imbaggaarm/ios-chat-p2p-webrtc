//
//  FriendTableViewCell.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/27/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class FriendTableViewCell: IMBBaseTableViewCell {
    
    var cellVM: FriendCellVM? {
        didSet {
            self.showData()
        }
    }
    
    let imgVAvatar: UIImageView = {
        let temp = UIImageView()
        temp.backgroundColor = UIColor.white
        temp.clipsToBounds = true
        temp.image = UIImage.init(named: "tim")
        temp.contentMode = .scaleAspectFill
        return temp
    }()
    
    let lblName: UILabel = {
        let temp = UILabel()
        temp.text = "Tai Duong"
        temp.font = UIFont.boldSystemFont(ofSize: 17)
        temp.numberOfLines = 0
        return temp
    }()
    
    let vOnlineStatus: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.green
        return temp
    }()
    
    override func setUpLayout() {
        super.setUpLayout()
        
        backgroundColor = .black
        
        contentView.addSubviews(subviews: imgVAvatar, lblName, vOnlineStatus)
        
        contentView.addConstraintsWith(format: "H:|-16-[v0]-10-[v1]-10-[v2]-16-|", views: imgVAvatar, lblName, vOnlineStatus)

        contentView.addConstraintsWith(format: "V:|-8-[v0]-8-|", views: imgVAvatar)
        imgVAvatar.makeCircle(corner: 30)
        
        lblName.centerYAnchor(with: contentView)
        
        vOnlineStatus.centerYAnchor(with: contentView)
        vOnlineStatus.makeCircle(corner: 6)
        
    }
    
    override func showData() {
        super.showData()
        
        guard let vm = cellVM else {
            return
        }
        
        imgVAvatar.kf.setImage(with: vm.imageURL)
        lblName.text = vm.name
        vOnlineStatus.backgroundColor = vm.onlineStateColor
    }
}
