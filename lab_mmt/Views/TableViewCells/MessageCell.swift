//
//  MessageCell.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/27/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit
import Kingfisher

class MessageCell: IMBBaseTableViewCell {
    
    var cellVM: MessageCellVM? {
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
        temp.font = UIFont.boldSystemFont(ofSize: 16)
        temp.numberOfLines = 1
        return temp
    }()
    
    let lblTime: UILabel = {
        let temp = UILabel()
        temp.textAlignment = .right
        temp.textColor = .darkGray
        temp.font = UIFont.systemFont(ofSize: 12)
        temp.text = "13:02"
        return temp
    }()
    
    let lblMessage: UILabel = {
        let temp = UILabel()
        temp.text = "Hello Alley"
        temp.textColor = .lightGray
        temp.numberOfLines = 0
        temp.font = UIFont.systemFont(ofSize: 15)
        return temp
    }()
    
    override func setUpLayout() {
        super.setUpLayout()
        
        contentView.backgroundColor = .black
        
        selectionStyle = .none
        
        contentView.addSubviews(subviews: imgVAvatar, lblName, lblTime, lblMessage)
        contentView.addConstraintsWith(format: "H:|-8-[v0]-8-[v1]-8-[v2]-8-|", views: imgVAvatar, lblName, lblTime)
        contentView.addConstraintsWith(format: "H:[v0]-8-[v1]-8-|", views: imgVAvatar, lblMessage)
        contentView.addConstraintsWith(format: "V:|-8-[v0]", views: imgVAvatar)
        contentView.addConstraintsWith(format: "V:|-8-[v0(20)]-2-[v1]", views: lblName, lblMessage)
        
        lblTime.centerYAnchor(with: lblName)
        
        imgVAvatar.makeCircle(corner: 20)
        
    }
    
    override func showData() {
        super.showData()
        
        guard let vm = cellVM else {
            return
        }
        imgVAvatar.kf.setImage(with: vm.avtImageURL)
        lblName.text = vm.name
        lblTime.text = vm.time
        lblMessage.text = vm.message
    }
}
