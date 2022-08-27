//
//  UserEndpoints.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation

internal enum UserEndpoints: ApiEndpoint {
    
    case users
    case user(Int)
    
    var path: String {
        switch self {
        case .users:
            return "/challenge/api/users"
        case .user(let id):
#warning("Discussion - would be nice to have pagination or to get a certain user")
            return "/challenge/api/user?userId=\(id)"
        }
    }
    
    var headers: ApiHeaders {
        [:]
    }
    
    var requestType: ApiMethod {
        ApiMethod.GET
    }
    
}
