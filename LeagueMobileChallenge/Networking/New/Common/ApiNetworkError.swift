//
//  ApiNetworkError.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation

enum ApiNetworkError: LocalizedError {
    case invalidURL
    case responseWithStatusCode(Int)
    case invalidAuthToken
    case parsingError
    case missingData
    case noInternetConnection
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Wrong URL components"
        case .responseWithStatusCode(let statusCode):
            return "Request failed with HTTP status code \(statusCode)"
        case .invalidAuthToken:
            return "Invalid authentication token"
        case .parsingError:
            return "Failed to parse network response"
        case .missingData:
            return "Network resul is missing data"
        case .noInternetConnection:
            return "No internet connection"
        }
    }
}
