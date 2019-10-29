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
    
    let lblName: UILabel = {
        let temp = UILabel()
        temp.font = UIFont.boldSystemFont(ofSize: 23)
        temp.textColor = .white
        temp.numberOfLines = 0
        temp.textAlignment = .center
        return temp
    }()
    
    let btnMessage: UIButton = {
        let temp = UIButton()
        temp.backgroundColor = AppColor.themeColor
        temp.titleLabel?.textColor = .white
        temp.setTitle("Nhắn tin", for: .normal)
        temp.layer.cornerRadius = 4
        return temp
    }()
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .automatic
        
//        navigationItem.title = AppString.profile
        
    }
    
    override func setUpLayout() {
        super.setUpLayout()
        
        view.backgroundColor = AppColor.backgroundColor
        
        view.addSubviews(subviews: coverImageView, avtImageView, lblName, btnMessage)
        view.addConstraintsWith(format: "V:[v0]-15-[v1]-25-[v2(35)]", views: avtImageView, lblName, btnMessage)

        view.addConstraintsWith(format: "H:|-16-[v0]-16-|", views: coverImageView)
        view.addConstraintsWith(format: "H:|-16-[v0]-16-|", views: lblName)
        view.addConstraintsWith(format: "H:|-16-[v0]-16-|", views: btnMessage)
        coverImageView.topAnchor(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16)
        
        coverImageView.roundCorners(corners: [.topLeft, .topRight], radius: 12, bounds: CGRect.init(x: 0, y: 0, width: widthOfScreen - 32, height: 1000))
        
        coverImageView.bottomAnchor(equalTo: avtImageView.centerYAnchor)
        
        avtImageView.topAnchor(equalTo: view.layoutMarginsGuide.topAnchor, constant: (widthOfScreen - 32)*1/3)
        avtImageView.centerXAnchor(with: view)
        avtImageView.makeCircle(corner: widthOfScreen/4)

//        lblName.centerXAnchor(with: view)
//        lblName.widthAnchor(equalTo: view.widthAnchor, multiplier: 0.9, constant: 0)
//
//        btnMessage.centerXAnchor(with: view)
//        btnMessage.widthAnchor(equalTo: view.widthAnchor, multiplier: 0.9, constant: 0)
    }
}

class ProfileVC: ProfileVCLayout {
    
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showData()
    }
    
    override func showData() {
        avtImageView.kf.setImage(with: URL.init(string: user.avtStrURL))
        coverImageView.kf.setImage(with: URL.init(string: user.coverStrURL))
        lblName.text = user.displayName
        title = user.displayName
        
    }
}
