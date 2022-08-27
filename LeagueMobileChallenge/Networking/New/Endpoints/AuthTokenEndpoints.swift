//
//  AuthTokenEndpoints.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation

internal enum AuthTokenEndpoints: ApiEndpoint {
    
    case getAuthToken
    
    var path: String {
        "/challenge/api/login"
    }
    
    var headers: ApiHeaders {
        let username = ""
        let password = ""
        let credentials = Data("\(username):\(password)".utf8).base64EncodedString()
        return [ApiHeaderKeys.authorization.rawValue: credentials]
    }
    
    var requestType: ApiMethod {
        ApiMethod.GET
    }
    

}
