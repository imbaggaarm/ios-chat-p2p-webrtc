//
//  User.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/28/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Foundation

enum P2POnlineState: Int, Codable {
    case offline = 0
    case online = 1
    case doNotDisturb = 2
    case idle = 3
}

enum WSOnlineState: Int, Codable {
    case offline = 0
    case online = 1
    case doNotDisturb = 2
}

var myFriends = [UserProfile]()

struct UserAccount: Codable {
    let email: String
    let password: String
}

class UserProfile: Codable {
    static let this: UserProfile = UserProfile(email: "", username: "", displayName: "", profilePictureUrl: "", coverPhotoUrl: "", state: .online, p2pState: .online)
    
    var email: String
    var username: String
    var displayName: String
    var profilePictureUrl: String
    var coverPhotoUrl: String
    var state: WSOnlineState = .offline {
        didSet {
            setP2pState()
        }
    }
    var p2pState: P2POnlineState = .offline
    var jwt: String = ""
    
    init(email: String, username: String, displayName: String, profilePictureUrl: String, coverPhotoUrl: String, state: WSOnlineState = .offline, p2pState: P2POnlineState = .offline) {
        self.email = email
        self.username = username
        self.displayName = displayName
        self.profilePictureUrl = profilePictureUrl
        self.coverPhotoUrl = coverPhotoUrl
        self.state = state
        self.p2pState = p2pState
    }
    
    func copy(from u: UserProfile) {
        self.email = u.email
        self.username = u.username
        self.displayName = u.displayName
        self.profilePictureUrl = u.profilePictureUrl
        self.coverPhotoUrl = u.coverPhotoUrl
        
        //not copy state and p2pstate, jwt
        //self.state = u.state
    }
    
    func setP2pState() {
        if self.state == .online {
            self.p2pState = .idle
            return
        }
        self.p2pState = P2POnlineState.init(rawValue: self.state.rawValue)!
    }
}

extension UserProfile {
    enum CodingKeys: String, CodingKey {
        case email
        case username
        case displayName = "display_name"
        case profilePictureUrl = "profile_picture_url"
        case coverPhotoUrl = "cover_photo_url"
        case state = "online_state"
    }
}
