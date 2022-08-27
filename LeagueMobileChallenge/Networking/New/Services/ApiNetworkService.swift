//
//  ApiNetworkService.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation

public typealias AuthToken = String

protocol ApiNetworkServiceProtocol: AnyObject {
    @discardableResult
    func perform(requestWith endpoint: ApiEndpoint,
                 authToken: AuthToken?,
                 completion: @escaping (Result<Data, ApiNetworkError>) -> Void) -> URLSessionDataTask?
}

class ApiNetworkService: ApiNetworkServiceProtocol {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func perform(requestWith endpoint: ApiEndpoint,
                 authToken: AuthToken? = nil,
                 completion: @escaping (Result<Data, ApiNetworkError>) -> Void) -> URLSessionDataTask? {
        let result = endpoint.createRequest(authToken: authToken)
        switch result {
        case .success(let request):
            let task = urlSession.dataTask(with: request) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.responseWithStatusCode(-1)))
                    return
                }
                guard httpResponse.statusCode == 200 else {
                    completion(.failure(.responseWithStatusCode(httpResponse.statusCode)))
                    return
                }
                guard let data = data else {
                    completion(.failure(.missingData))
                    return
                }
                completion(.success(data))
            }
            task.resume()
            return task
        case .failure(let error):
            completion(.failure(error))
            return nil
        }
    }
    
}

