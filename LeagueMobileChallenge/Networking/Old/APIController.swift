//
//  APIController.swift
//  LeagueMobileChallenge
//
//  Created by Kelvin Lau on 2019-01-14.
//  Copyright © 2019 Kelvin Lau. All rights reserved.
//

import Foundation
import Alamofire

class APIController {
    static let user = "user"
    static let password = "password"
    
    static let domain = "https://engineering.league.dev/challenge/api/"
    let loginAPI = domain + "login"
    let postAPI = domain + "posts"
    let userAPI = domain + "users"
    
    static let shared = APIController()
    
    fileprivate var userToken: String?
    
    func fetchUserToken(userName: String = "", password: String = "", completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: loginAPI) else {
            return
        }
        let headers: HTTPHeaders = [
            .authorization(username: userName, password: password)
        ]
        
        _ = AF.request(url, headers: headers)
            .responseData { response in
            switch response.result {
            case .success(let value):
                do{
                    let json = try JSONSerialization.jsonObject(with: value, options: []) as? [String : String]
                    self.userToken = json?["api_key"]
                }catch{
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchPosts(completion: @escaping (Any?, Error?) -> Void) {
        guard let url = URL(string: postAPI) else {
            return
        }
        
        request(url: url) { data, error in
            completion(data, error)
        }
        
    }
    
    func fetchUsers(completion: @escaping (Any?, Error?) -> Void) {
        guard let url = URL(string: userAPI) else {
            return
        }
        request(url: url) { data, error in
            completion(data, error)
        }
    }
    
    func request(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        guard let userToken = userToken else {
            NSLog("No user token set")
            completion(nil, nil)
            return
        }
        let authHeader: HTTPHeaders = ["x-access-token" : userToken]
        _ =  AF.request(url,
                        method: .get,
                        parameters: nil,
                        encoding: URLEncoding.default,
                        headers: authHeader)
        .responseData { response in
            completion(response.data, response.error)
        }
    }
}
