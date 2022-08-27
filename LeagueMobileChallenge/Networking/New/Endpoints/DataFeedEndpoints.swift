//
//  DataFeedEndpoints.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation

internal enum DataFeedEndpoints: ApiEndpoint {
    
    case posts
    
    var path: String {
        "/challenge/api/posts"
    }
    
    var headers: ApiHeaders {
        [:]
    }
    
    var requestType: ApiMethod {
        ApiMethod.GET
    }
    
}
