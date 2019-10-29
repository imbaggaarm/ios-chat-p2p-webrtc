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

class User {
    let username: String
    let password: String
    let displayName: String
    
    let avtStrURL: String
    let coverStrURL: String
    
    var state: OnlineState
    
    static var this: User!
    
    init(username: String, password: String, displayName: String, avtStrURL: String, coverStrURL: String, onlineState: OnlineState = .offline) {
        self.username = username
        self.password = password
        self.displayName = displayName
        self.avtStrURL = avtStrURL
        self.coverStrURL = coverStrURL
        self.state = onlineState
    }
}

let allUsers = [
    User.init(username: "user1", password: "", displayName: "Tài Dương", avtStrURL: "https://scontent.fsgn3-1.fna.fbcdn.net/v/t1.0-9/72770272_937416046627629_8601799044018208768_o.jpg?_nc_cat=107&cachebreaker=sd&_nc_oc=AQnwqH0EO0dQARI-ztmAXlPwc8u2WWLIrPG7sSgZlVxyZPVgRSTxU_zAYy0_cWCb8sY&_nc_ht=scontent.fsgn3-1.fna&oh=ef5692abe03095bb89992c91225c110b&oe=5E17544D", coverStrURL: "https://scontent.fsgn3-1.fna.fbcdn.net/v/t1.0-9/72770272_937416046627629_8601799044018208768_o.jpg?_nc_cat=107&cachebreaker=sd&_nc_oc=AQnwqH0EO0dQARI-ztmAXlPwc8u2WWLIrPG7sSgZlVxyZPVgRSTxU_zAYy0_cWCb8sY&_nc_ht=scontent.fsgn3-1.fna&oh=ef5692abe03095bb89992c91225c110b&oe=5E17544D"),
    
    User.init(username: "user2", password: "", displayName: "Thức Trần", avtStrURL: "https://scontent.fsgn4-1.fna.fbcdn.net/v/t1.0-9/48364556_334991657092752_8475428367296888832_n.jpg?_nc_cat=103&cachebreaker=sd&_nc_oc=AQkOvex4QNZZunBh1zUcLSqxiZFsLH3KQgKAS1fu_c1DSr-uqXjectxRXuDsnGJNYds&_nc_ht=scontent.fsgn4-1.fna&oh=5eca8adb3876a99dbd2d212392408c3a&oe=5E548584", coverStrURL: "https://scontent.fsgn4-1.fna.fbcdn.net/v/t1.0-9/48364556_334991657092752_8475428367296888832_n.jpg?_nc_cat=103&cachebreaker=sd&_nc_oc=AQkOvex4QNZZunBh1zUcLSqxiZFsLH3KQgKAS1fu_c1DSr-uqXjectxRXuDsnGJNYds&_nc_ht=scontent.fsgn4-1.fna&oh=5eca8adb3876a99dbd2d212392408c3a&oe=5E548584"),
    
    User.init(username: "user3", password: "", displayName: "Công Linh", avtStrURL: "https://scontent.fsgn3-1.fna.fbcdn.net/v/t1.0-9/73148067_1463965623778887_510412543362072576_o.jpg?_nc_cat=111&cachebreaker=sd&_nc_oc=AQlrb5LwhJUpgTz6FvXLwUeU4hzRobK6stNXwd4r8Nf-TDECznkMnRJQ7iJr2C-N8s0&_nc_ht=scontent.fsgn3-1.fna&oh=3d2d871bc31872116e4d3dc363eb3192&oe=5E54A066", coverStrURL: "https://scontent.fsgn3-1.fna.fbcdn.net/v/t1.0-9/73148067_1463965623778887_510412543362072576_o.jpg?_nc_cat=111&cachebreaker=sd&_nc_oc=AQlrb5LwhJUpgTz6FvXLwUeU4hzRobK6stNXwd4r8Nf-TDECznkMnRJQ7iJr2C-N8s0&_nc_ht=scontent.fsgn3-1.fna&oh=3d2d871bc31872116e4d3dc363eb3192&oe=5E54A066"),
    User.init(username: "user4", password: "", displayName: "Tuấn Trần", avtStrURL: "https://scontent.fsgn3-1.fna.fbcdn.net/v/t1.0-1/19366599_851641698321246_3156420856808843114_n.jpg?_nc_cat=107&cachebreaker=sd&_nc_oc=AQmn6BpDCH_hKfl52ZT3AS50SpRuiOvUc78N_4PlRUc3MlXsj363BSrlX8oEo8pQe00&_nc_ht=scontent.fsgn3-1.fna&oh=54befe7439a29ddab67098312266ff98&oe=5E1F1980", coverStrURL: "https://scontent.fsgn3-1.fna.fbcdn.net/v/t1.0-1/19366599_851641698321246_3156420856808843114_n.jpg?_nc_cat=107&cachebreaker=sd&_nc_oc=AQmn6BpDCH_hKfl52ZT3AS50SpRuiOvUc78N_4PlRUc3MlXsj363BSrlX8oEo8pQe00&_nc_ht=scontent.fsgn3-1.fna&oh=54befe7439a29ddab67098312266ff98&oe=5E1F1980"),
]

fileprivate func getFriends() -> [User] {
    var friends = [User]()
    _ = allUsers.map {
        if $0.username != User.this.username {
            friends.append($0)
        }
    }
    
    return friends
}

var friends = getFriends()
