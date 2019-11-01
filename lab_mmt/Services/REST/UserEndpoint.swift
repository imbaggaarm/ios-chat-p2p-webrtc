//
//  UserEndpoint.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/30/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation
import Alamofire

enum UserEndPoint: APIConfiguration {
    case login(email: String, password: String)
    case profile(username: String)
    case friends(username: String)
    // MARK: HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .profile:
            return .get
        case .friends:
            return .get
        }
    }
        
    // MARK: - Path
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .profile(let username):
            return "/\(username)"
        case .friends(let username):
            return "/\(username)/friends"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return [K.APIParameterKey.email: email, K.APIParameterKey.password: password]
        case .profile:
            return nil
        case .friends:
            return nil
        }
    }
    
//    func asURLRequest() throws -> URLRequest {
//        let url = try K.ProductionServer.baseURL.asURL()
//
//        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
//
//        // HTTP Method
//        urlRequest.httpMethod = method.rawValue
//
//        // Common Headers
//        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
//        urlRequest.setValue(ContentType.form_urlencoded.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
//
//        // Parameters
//        if let parameters = parameters {
//            let parameterArray = parameters.map { (key, value) -> String in
//                return "\(key)=\(self.percentEscapeString(string: value as! String))"
//            }
//
//            urlRequest.httpBody = parameterArray.joined(separator: "&").data(using: .utf8)
//        }
//
//        return urlRequest
//    }
}
