//
//  ApiEndpoint.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation

enum ApiMethod: String {
    case GET
}

enum ApiHeaderKeys: String {
    case authorization = "Authorization"
    case accessToken = "x-access-token"
}

public typealias ApiHeaders = [String: String]

protocol ApiEndpoint {
    var path: String { get }
    var requestType: ApiMethod { get }
    var headers: ApiHeaders { get }
}

extension ApiEndpoint {
    var host: String {
        ApiConstants.baseURL
    }
    var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }
}

extension ApiEndpoint {
    func createRequest(authToken: AuthToken? = nil) -> Result<URLRequest, ApiNetworkError> {
        var components =  URLComponents()
        components.scheme = ApiConstants.HttpScema.https.rawValue
        components.host = host
        components.path = path
        guard let url = components.url else {
            return .failure(ApiNetworkError.invalidURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        if let authToken = authToken {
            urlRequest.addValue(authToken, forHTTPHeaderField: ApiHeaderKeys.accessToken.rawValue)
        }
        return .success(urlRequest)
    }
}

