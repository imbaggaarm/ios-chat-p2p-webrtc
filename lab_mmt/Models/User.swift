//
//  User.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/28/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation

enum OnlineState {
    case online, offline, doNotDisturb
}

struct LoginResponseData: Codable {
    let jwt: String
    let username: String
}

protocol Response {
    var type: String { get set }
    var success: Bool { get set }
    var error: String { get set }
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

struct UserAccount: Codable {
    let email: String
    let password: String
}

class UserProfile: Codable {
    static var this: UserProfile = UserProfile(email: "", username: "", displayName: "", profilePictureUrl: "", coverPhotoUrl: "")
    
    var email: String
    var username: String
    var displayName: String
    var profilePictureUrl: String
    var coverPhotoUrl: String
    var state: OnlineState = .offline
    
    init(email: String, username: String, displayName: String, profilePictureUrl: String, coverPhotoUrl: String, state: OnlineState = .offline) {
        self.email = email
        self.username = username
        self.displayName = displayName
        self.profilePictureUrl = profilePictureUrl
        self.coverPhotoUrl = coverPhotoUrl
        self.state = state
    }
}

extension UserProfile {
    enum CodingKeys: String, CodingKey {
        case email
        case username
        case displayName = "display_name"
        case profilePictureUrl = "profile_picture_url"
        case coverPhotoUrl = "cover_photo_url"
    }
}

var myFriends = [UserProfile]()
//
//class User {
//    let username: String
//    let password: String
//    let displayName: String
//
//    let avtStrURL: String
//    let coverStrURL: String
//
//    var state: OnlineState
//
////    static var this: User!
//
//    init(username: String, password: String, displayName: String, avtStrURL: String, coverStrURL: String, onlineState: OnlineState = .offline) {
//        self.username = username
//        self.password = password
//        self.displayName = displayName
//        self.avtStrURL = avtStrURL
//        self.coverStrURL = coverStrURL
//        self.state = onlineState
//    }
//}
