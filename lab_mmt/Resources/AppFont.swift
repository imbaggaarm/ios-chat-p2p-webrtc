//
//  AppFont.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 11/1/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class AppFont {
    static let logInButtonTitleFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    
    static let startVCLblTitleFont: UIFont = {
        if AppConstant.myScreenType == .iPhone5 {
            return UIFont.systemFont(ofSize: 25, weight: .bold)//avenirNext(size: 25, type: .bold)
        }
        return UIFont.systemFont(ofSize: 30, weight: .bold)//avenirNext(size: 30, type: .bold)
    }()
    
    static let logInLblTitleFont: UIFont = {
        if AppConstant.myScreenType == .iPhone5 {
            return UIFont.systemFont(ofSize: 18, weight: .medium)//avenirNext(size: 18, type: .demiBold)
        }
        return UIFont.systemFont(ofSize: 20, weight: .medium)//avenirNext(size: 20, type: .demiBold)
    }()
}
