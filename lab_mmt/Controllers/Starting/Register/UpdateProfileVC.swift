//
//  UpdateProfileVC.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 11/1/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class UpdateProfileVC: BaseViewControllerLayout {
    
    let avtImageView: UIImageView = {
        let temp = UIImageView()
        temp.clipsToBounds = true
        temp.layer.borderColor = AppColor.backgroundColor.cgColor
        temp.layer.borderWidth = 6
        temp.backgroundColor = .darkGray
        temp.image = AppIcon.userAvtPlaceholder
        return temp
    }()
    
    let coverImageView: UIImageView = {
        let temp = UIImageView()
        temp.backgroundColor = .darkGray
        temp.contentMode = .scaleAspectFill
        temp.clipsToBounds = true
        temp.image = AppIcon.imagePlaceHolder
        return temp
    }()
    
    let txtFUsername: UILabel = {
        let temp = UILabel()
        temp.font = UIFont.boldSystemFont(ofSize: 23)
        temp.textColor = .white
        return temp
    }()
    
    let txtDisplayName: UILabel = {
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 18)
        temp.textColor = .white
        return temp
    }()
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Cập nhật thông tin"
    }
    
    override func setUpLayout() {
        super.setUpLayout()
        
        view.backgroundColor = AppColor.backgroundColor
        
        view.addSubviews(subviews: coverImageView, avtImageView, txtFUsername, txtDisplayName)
        view.addConstraintsWith(format: "V:[v0]-15-[v1]-15-[v2]", views: avtImageView, txtFUsername, txtDisplayName)

        view.addConstraintsWith(format: "H:|-16-[v0]-16-|", views: coverImageView)
        view.addConstraintsWith(format: "H:|-16-[v0]-16-|", views: txtFUsername)
        view.addConstraintsWith(format: "H:|-16-[v0]-16-|", views: txtDisplayName)
        
        coverImageView.topAnchor(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16)
        coverImageView.roundCorners(corners: [.topLeft, .topRight], radius: 12, bounds: CGRect.init(x: 0, y: 0, width: widthOfScreen - 32, height: 1000))
        coverImageView.height(constant: (widthOfScreen - 32)*1/3 + widthOfScreen/4 - 16)
        
        avtImageView.topAnchor(equalTo: coverImageView.bottomAnchor, constant: -widthOfScreen/4)
        avtImageView.centerXAnchor(with: view)
        avtImageView.makeCircle(corner: widthOfScreen/4)

    }

}
