//
//  RESTfulAPIClient.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/30/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Alamofire

final class APIClient {
    static func login(email: String, password: String, completion: @escaping (AFResult<LoginResponse>) -> Void) {
        let router = APIRouter.login(email: email, password: password)
        AF.request(router).responseDecodable{ (response: AFDataResponse<LoginResponse>) in
            completion(response.result)
        }
    }
    
    static func getUserProfile(username: String, completion: @escaping (AFResult<UserProfileResponse>) -> Void) {
        let router = UserEndPoint.profile(username: username)
        AF.request(router).responseDecodable { (response: AFDataResponse<UserProfileResponse>) in
            completion(response.result)
        }
    }
    
    static func getUserFriends(username: String, completion: @escaping (AFResult<UserFriendsResponse>) -> Void) {
        let router = UserEndPoint.friends(username: username)
        AF.request(router).responseDecodable { (response: AFDataResponse<UserFriendsResponse>) in
            completion(response.result)
        }
    }

}
