//
//  RESTfulAPIClient.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/30/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import Alamofire
import PromisedFuture

final class APIClient {
    @discardableResult
    private static func performRequest<T:Decodable>(route: URLRequestConvertible, decoder: JSONDecoder = JSONDecoder()) -> Future<T> {
        return Future(operation: { completion in
            AF.request(route).responseDecodable(decoder: decoder, completionHandler: { (response: AFDataResponse<T>) -> Void in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        })
    }
    
    static func login(email: String, password: String) -> Future<LoginResponse> {
        let route = APIRouter.login(email: email, password: password)
        return performRequest(route: route)
    }
    
    static func getUserProfile(username: String) -> Future<UserProfileResponse> {
        let route = UserEndPoint.profile(username: username)
        return performRequest(route: route)
    }
    
    static func getUserFriends(username: String) -> Future<UserFriendsResponse> {
        let route = UserEndPoint.friends(username: username)
        return performRequest(route: route)
    }

}
