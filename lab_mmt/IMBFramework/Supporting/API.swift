//
//  API.swift
//  appECONVEETEMP
//
//  Created by Tai Duong on 1/3/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import UIKit

let domain: String = "http://imbaggaarm.com/taiduong/"
enum API: String {
    
    case postEmail = "testWord.php"
    
    var fullLink: String{
        return domain + rawValue
    }
}
