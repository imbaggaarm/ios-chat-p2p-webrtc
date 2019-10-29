//
//  IMBBasePopUpViewController.swift
//  appMapBoxSwiftTemp
//
//  Created by Tai Duong on 1/13/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import UIKit

class IMBBasePopUpViewController: IMBBaseViewController
{
    weak var completionDelegate: IMBBasePopUpViewControllerDelegate?
    let vBlackBackground: UIView = {
        let temp = UIView()
        temp.alpha = 0
        temp.backgroundColor = .black
        
        return temp
    }()
    
    let contentView: UIView = {
        let temp = UIView()
        temp.backgroundColor = .white
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataWhenPopUp()
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleTapBackgroundView))
        vBlackBackground.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popUpAnimation()
    }
    
    override func customMySelf() {
        view.backgroundColor = .clear
    }
    
    var popUpDuration: TimeInterval = 0.3
    var dismissDuration: TimeInterval = 0.3
    var springWithDamping: CGFloat = 0.75
    var initialSpringVelocity: CGFloat = 2.5
    var topConstantOfContentViewTop: CGFloat = 0
    var alphaOfVBlackBackground: CGFloat = 0.2
    
    func popUpAnimation() {
        contentViewTop.constant = topConstantOfContentViewTop
        UIView.animate(withDuration: popUpDuration, delay: 0, usingSpringWithDamping: springWithDamping, initialSpringVelocity: initialSpringVelocity, options: .curveEaseIn, animations: {
            self.vBlackBackground.alpha = self.alphaOfVBlackBackground
            self.view.layoutIfNeeded()
        }, completion: popUpCompletion)
        
    }
    
    var popUpCompletion: ((Bool) -> Void)?
    
    func dismissWithMyAnimation(completion: (() -> Void)?) {
        completionBeforeDismiss()
        dismissAnimation(completion: completion)
    }
    
    func completionBeforeDismiss() {
        
    }
    
    func dismissAnimation(completion: (() -> Void)?) {
        view.endEditing(true)
        contentViewTop.constant = 0
        
        UIView.animate(withDuration: dismissDuration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 2.5, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.view.alpha = 0
        }, completion: { _ in
            self.dismiss(animated: false, completion: completion)
        })
    }
    
    @objc func dismissWithNonCompletion() {
        dismissWithMyAnimation(completion: nil)
    }
    
    override func setUpSubviews() {
        super.setUpSubviews()
        setUpContentView()

    }
    
    var contentViewTop: NSLayoutConstraint!
    
    func setUpContentView() {
        
    }
    
    override func setUpLayout() {
        super.setUpLayout()
        view.addConstraintsWith(format: "V:|[v0]|", views: vBlackBackground)
        view.addConstraintsWith(format: "H:|[v0]|", views: vBlackBackground)
        
        contentView.centerXAnchor(with: view)
        contentViewTop = contentView.topAnchor.constraint(equalTo: view.bottomAnchor)
        contentViewTop.isActive = true
    }
    
    override func addSubviews() {
        view.addSubview(vBlackBackground)
        view.addSubview(contentView)
    }
    
    func loadDataWhenPopUp() {
        
    }
    
    @objc func handleTapBackgroundView() {
        dismissWithNonCompletion()
    }
}

@objc protocol IMBBasePopUpViewControllerDelegate
{
    @objc optional func popUpViewControllerCompletionHandler(popUpVC: IMBBasePopUpViewController)
}
