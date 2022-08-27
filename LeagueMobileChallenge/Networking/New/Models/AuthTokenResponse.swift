//
//  AuthTokenResponse.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation

//{
//    "api_key": "5ECDDC3A21CE53428227A2125B7FCC71"
//}

struct AuthTokenResponse: Decodable {
    var apiKey: String
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}

