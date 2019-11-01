//
//  AuthRouter.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 11/1/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation
import Alamofire

enum AuthRouter: APIConfiguration {
    case login(email: String, password: String)
    case register(email: String, password: String)
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .register:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return [K.APIParameterKey.email: email, K.APIParameterKey.password: password]
        case .register(let email, let password):
            return [K.APIParameterKey.email: email, K.APIParameterKey.password: password]
        }
    }
    
}
