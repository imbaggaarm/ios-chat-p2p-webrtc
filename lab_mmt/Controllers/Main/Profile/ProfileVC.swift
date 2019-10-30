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
        
        btnMessage.addTarget(self, action: #selector(onBtnMessageTapped), for: .touchUpInside)
    }
    
    @objc func onBtnMessageTapped() {
        let alertC = UIAlertController.init(title: "Thay đổi trạng thái", message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let online = UIAlertAction.init(title: "Online", style: .default) {[unowned self] (action) in
            self.user.state = .online
            self.setOnlineStateColor()
            //send to other users
            SignalingClient.default?.sendOnlineStateChange(username: self.user.username, state: .online)
        }
        
        let doNotDisturb = UIAlertAction.init(title: "Do not disturb", style: .default) {[unowned self] (action) in
            self.user.state = .doNotDisturb
            self.setOnlineStateColor()
            //send to other users
            SignalingClient.default?.sendOnlineStateChange(username: self.user.username, state: .doNotDisturb)
        }
        alertC.addAction(cancel)
        alertC.addAction(online)
        alertC.addAction(doNotDisturb)
        present(alertC, animated: true, completion: nil)
    }
    
    override func showData() {
        avtImageView.kf.setImage(with: URL.init(string: user.profilePictureUrl))
        coverImageView.kf.setImage(with: URL.init(string: user.coverPhotoUrl))
        lblName.text = user.displayName
        lblEmail.text = user.email
        title = user.displayName
        
        if user.email == UserProfile.this.email {
            btnMessage.setTitle("Thay đổi trạng thái", for: .normal)
        } else {
            btnMessage.setTitle("Gửi tin nhắn", for: .normal)
        }
        setOnlineStateColor()
    }
    
    func setOnlineStateColor() {
        var color: UIColor
        switch user.p2pState {
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
}
