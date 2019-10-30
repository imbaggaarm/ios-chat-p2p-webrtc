//
//  ProfileVCLayout.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/29/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class ProfileVCLayout: BaseViewControllerLayout {
    
    let avtImageView: UIImageView = {
        let temp = UIImageView()
        temp.clipsToBounds = true
        temp.layer.borderColor = AppColor.backgroundColor.cgColor
        temp.layer.borderWidth = 6
        return temp
    }()
    
    let coverImageView: UIImageView = {
        let temp = UIImageView()
        temp.backgroundColor = .darkGray
        temp.contentMode = .scaleAspectFill
        temp.clipsToBounds = true
        return temp
    }()
    
    let vOnlineState: UIView = {
        let temp = UIView()
        temp.backgroundColor = .gray
        temp.layer.borderColor = AppColor.backgroundColor.cgColor
        temp.layer.borderWidth = 4
        return temp
    }()
    
    let lblName: UILabel = {
        let temp = UILabel()
        temp.font = UIFont.boldSystemFont(ofSize: 23)
        temp.textColor = .white
        temp.numberOfLines = 0
        temp.textAlignment = .center
        return temp
    }()
    
    let lblEmail: UILabel = {
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 18)
        temp.textColor = .gray
        temp.numberOfLines = 1
        temp.textAlignment = .center
        return temp
    }()
    
    let btnMessage: UIButton = {
        let temp = UIButton()
        temp.backgroundColor = AppColor.themeColor
        temp.titleLabel?.textColor = .white
        temp.layer.cornerRadius = 4
        return temp
    }()
    
    override func setUpLayout() {
        super.setUpLayout()
        
        view.backgroundColor = AppColor.backgroundColor
        
        view.addSubviews(subviews: coverImageView, avtImageView, lblName, lblEmail, btnMessage, vOnlineState)
        view.addConstraintsWith(format: "V:[v0]-15-[v1]-15-[v2]-25-[v3(35)]", views: avtImageView, lblName, lblEmail, btnMessage)

        view.addConstraintsWith(format: "H:|-16-[v0]-16-|", views: coverImageView)
        view.addConstraintsWith(format: "H:|-16-[v0]-16-|", views: lblName)
        view.addConstraintsWith(format: "H:|-16-[v0]-16-|", views: lblEmail)
        view.addConstraintsWith(format: "H:|-16-[v0]-16-|", views: btnMessage)
        
        coverImageView.topAnchor(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16)
        coverImageView.roundCorners(corners: [.topLeft, .topRight], radius: 12, bounds: CGRect.init(x: 0, y: 0, width: widthOfScreen - 32, height: 1000))
        coverImageView.bottomAnchor(equalTo: avtImageView.centerYAnchor)
        
        avtImageView.topAnchor(equalTo: view.layoutMarginsGuide.topAnchor, constant: (widthOfScreen - 32)*1/3)
        avtImageView.centerXAnchor(with: view)
        avtImageView.makeCircle(corner: widthOfScreen/4)

        vOnlineState.makeCircle(corner: 16)
        vOnlineState.topAnchor(equalTo: avtImageView.topAnchor, constant: (CGFloat(2.0.squareRoot()/2.0) + 1)*(widthOfScreen - 12)/4 - 16)
        vOnlineState.leftAnchor(equalTo: avtImageView.leftAnchor, constant: (CGFloat(2.0.squareRoot()/2.0) + 1)*(widthOfScreen - 12)/4 - 16)
    }
}

