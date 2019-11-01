//
//  LoginVC.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/11/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit

class WelcomeVC: WelcomeVCLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        butRegister.addTarget(self, action: #selector(handleTapButRegister), for: .touchUpInside)
    }
    
    
    @objc func handleTapButRegister() {
        presentRegisterVC()
    }
    
    //handle touch login text
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        presentLoginVC()
        return false
    }
    
    func presentLoginVC() {
        let loginVC = showWelcomVC()
        let navC = UINavigationController.init(rootViewController: loginVC)
        present(navC, animated: true, completion: nil)
    }

    func presentRegisterVC() {
        let registerVC = RegisterVC()
        let navC = UINavigationController.init(rootViewController: registerVC)
        present(navC, animated: true, completion: nil)
    }
}
