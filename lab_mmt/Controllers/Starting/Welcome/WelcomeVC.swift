//
//  LoginVC.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/11/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit

class WelcomeVC: WelcomeVCLayout {
    
    var shouldPresentMainVC: Bool = false {
        didSet {
            if self.shouldPresentMainVC {
                view.isHidden = true
                self.shouldPresentMainVC = false
            } else {
                view.isHidden = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        butRegister.addTarget(self, action: #selector(handleTapButRegister), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if shouldPresentMainVC {
//            shouldPresentMainVC = false
//
//        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//    }
    
    @objc func handleTapButRegister() {
        presentRegisterVC()
    }
    
    //handle touch login text
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        presentLoginVC()
        return false
    }
    
    func presentMainVC() {
        let webRTCClient = WebRTCClient(iceServers: Config.default.webRTCIceServers)
        let signalClient = SignalingClient()
        
        let mainVC = MainTabbarVC.init(signalClient: signalClient, webRTCClient: webRTCClient)
        mainVC.modalPresentationStyle = .overCurrentContext
        present(mainVC, animated: false, completion: nil)
    }
    
    func presentLoginVC() {
        let loginVC = LoginVC()
        let navC = UINavigationController.init(rootViewController: loginVC)
        present(navC, animated: true, completion: nil)
    }

    func presentRegisterVC() {
        let registerVC = RegisterVC()
        let navC = UINavigationController.init(rootViewController: registerVC)
        present(navC, animated: true, completion: nil)
    }
    
}
