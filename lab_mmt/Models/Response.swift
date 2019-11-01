//
//  Response.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/31/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation

protocol Response {
    var type: String { get set }
    var success: Bool { get set }
    var error: String { get set }
}

struct LoginResponseData: Codable {
    let token: String
    let username: String
    let email: String
}

struct LoginResponse: Response, Codable {
    var type: String
    
    var success: Bool
    
    var error: String
    
    let data: LoginResponseData?
}

struct UserProfileResponse: Response, Codable {
    var type: String
    
    var success: Bool
    
    var error: String
    
    let data: UserProfile?
}

struct UserFriendsResponse: Response, Codable {
    var type: String
    
    var success: Bool
    
    var error: String
    
    let data: [UserProfile]?
}
