//
//  AppConstant.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/27/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class AppConstant {
    static let myScreenType = UIDevice.current.screenType
    static let butBorderWidth: CGFloat = 1.5
    
    static let heightOfLoginButton: CGFloat = 40
}

struct K {
    struct ProductionServer {
        static let baseURL = Config.default.restServerUrl
    }
    
    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
        static let token = "token"
        static let displayName = "display_name"
        static let username = "username"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
    case form_urlencoded = "application/x-www-form-urlencoded"
}
