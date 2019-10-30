//
//  APIConfiguration.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/30/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

extension APIConfiguration {
    var headers: [(String, String)] {
        return [
            (HTTPHeaderField.acceptType.rawValue, ContentType.json.rawValue),
            (HTTPHeaderField.contentType.rawValue, ContentType.form_urlencoded.rawValue)
        ]
    }
    
    private func percentEscapeString(string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return string
          .addingPercentEncoding(withAllowedCharacters: characterSet)!
          .replacingOccurrences(of: " ", with: "+")
          .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }

    
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        headers.forEach { (field, value) in
            urlRequest.addValue(value, forHTTPHeaderField: field)
        }
        
        // Parameters
        if let parameters = self.parameters {
            let parameterArray = parameters.map { (key, value) -> String in
                return "\(key)=\(self.percentEscapeString(string: value as! String))"
            }
            
            urlRequest.httpBody = parameterArray.joined(separator: "&").data(using: .utf8)
        }
        
        return urlRequest
    }
}
