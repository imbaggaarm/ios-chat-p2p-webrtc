//
//  ProfileVC.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class ProfileVC: ProfileVCLayout {
    
    let user: UserProfile
    
    init(user: UserProfile) {
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
        avtImageView.kf.setImage(with: URL.init(string: user.profilePictureUrl))
        coverImageView.kf.setImage(with: URL.init(string: user.coverPhotoUrl))
        lblName.text = user.displayName
        lblEmail.text = user.email
        title = user.displayName
        
        if user.email == UserProfile.this.email {
            btnMessage.isHidden = true
        } else {
            btnMessage.isHidden = false
        }
    }
}
