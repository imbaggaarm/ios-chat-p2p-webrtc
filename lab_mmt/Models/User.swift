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

var myFriends = [UserProfile]()

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


