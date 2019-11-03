//
//  SettingsVCLayout.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/13/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SettingsVCLayout: BaseViewControllerLayout {
    
    let lblEmail: UILabel = {
        let temp = UILabel()
        temp.textAlignment = .center
        temp.textColor = .darkGray
        temp.font = AppFont.settingsVCLblEmailTxtFont
        return temp
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let temp = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        temp.isScrollEnabled = true
        temp.showsVerticalScrollIndicator = false
        return temp
    }()
    
    let blackBackgroundView: UIView = {
        let temp = UIView()
        temp.alpha = 0.4
        temp.backgroundColor = AppColor.backgroundColor
        temp.isHidden = true
        return temp
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let temp = NVActivityIndicatorView(frame: CGRect.init(x: widthOfScreen/2 - 30, y: heightOfScreen/2 - 30, width: 60, height: 60), type: .circleStrokeSpin, color: AppColor.white, padding: nil)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //present animation
        modalPresentationCapturesStatusBarAppearance = true
        
        view.backgroundColor = AppColor.backgroundColor
        
    }
    
    override func setUpNavigationBar() {
        super.setUpNavigationBar()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: AppIcon.dismissVC, style: .done, target: self, action: #selector(dismissMySelf))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = AppString.settingVCTitle
        
    }
    
    override func setUpLayout() {
        super.setUpLayout()
        
        do {
            view.addSubviews(subviews: collectionView, lblEmail)
            view.addConstraintsWith(format: "V:[v0]-20-[v1]|", views: lblEmail, collectionView)
            view.addSameConstraintsWith(format: "H:|[v0]|", for: lblEmail, collectionView)
            
            lblEmail.topAnchor(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10)
            navigationController?.view.addSubview(blackBackgroundView)
            blackBackgroundView.makeFullWithSuperView()
            navigationController?.view.addSubview(activityIndicator)
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setStatusBarStyle(style: .default)
    }

}
