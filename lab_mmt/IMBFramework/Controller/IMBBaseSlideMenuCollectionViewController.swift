//
//  IMBBaseSlideMenuCollectionViewController.swift
//  appMapBoxSwiftTemp
//
//  Created by Tai Duong on 1/18/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import UIKit

class IMBBaseSlideMenuCollectionViewController: IMBBaseSlideMenuController
{
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .vertical
        let temp = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        //temp.delegate = self
        //temp.dataSource = self
        temp.backgroundColor = .yellow
        //temp.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        return temp
    }()
    
    func setUpCollectionView()
    {
        
    }
    
    override func setUpSubviews() {
        super.setUpSubviews()
        setUpCollectionView()
    }
    
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(collectionView)
        
    }
    override func setUpLayout() {
        super.setUpLayout()
        //scrollView.frame = CGRect(x: 0, y: 0, width: widthOfScreen, height: heightOfScreen)
        //scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.addConstraintsWith(format: "V:|[v0]|", views: collectionView)
        contentView.addConstraintsWith(format: "H:|[v0]|", views: collectionView)
    }

}

//extension IMBBaseSlideMenuCollectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
//{
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//    }
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        <#code#>
//    }
//    
//}
