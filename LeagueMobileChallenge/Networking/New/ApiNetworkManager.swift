//
//  ApiNetworkManager.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation

protocol ApiNetworkManagerProtocol {
    func perform<T: Decodable>(requestWith endpoint: ApiEndpoint,
                               completion: @escaping (Result<T, ApiNetworkError>) -> Void)
}

class ApiNetworkManager: ApiNetworkManagerProtocol {
    private let apiNetworkService: ApiNetworkServiceProtocol
    private let apiStorageService: ApiStorageServiceProtocol
    private let apiReachabilityService: ApiReachabilityServiceProtocol
        
    private let serialNewtworkQueue = DispatchQueue(label: "com.LeagueMobileChallenge.SerialNetworking", attributes: .concurrent)
//    private let refreshDispatchGroup = DispatchGroup()
    
    init(apiNetworkService: ApiNetworkServiceProtocol = ApiNetworkService(),
         apiStorageService: ApiStorageServiceProtocol = ApiStorageService(),
         apiReachabilityService: ApiReachabilityServiceProtocol = ApiReachabilityService()) {
        self.apiNetworkService = apiNetworkService
        self.apiStorageService = apiStorageService
        self.apiReachabilityService = apiReachabilityService
    }
    
    func perform<T: Decodable>(requestWith endpoint: ApiEndpoint,
                               completion: @escaping (Result<T, ApiNetworkError>) -> Void) {
        guard apiReachabilityService.isNetworkReachable() else {
            completion(.failure(.noInternetConnection))
            return
        }
        let refreshDispatchGroup = DispatchGroup()
        refreshDispatchGroup.enter()
        serialNewtworkQueue.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.getAuthToken { requestResult in
                switch requestResult {
                case .success(let token):
                    self?.apiStorageService.updateToken(token)
                case .failure(let error):
                    completion(.failure(error))
                    refreshDispatchGroup.leave()
                    return
                }
                refreshDispatchGroup.leave()
            }
        }
        
        refreshDispatchGroup.notify(queue: DispatchQueue.main) {
            guard let authToken = self.apiStorageService.getToken() else {
                completion(.failure(ApiNetworkError.invalidAuthToken))
                return
            }
            self.apiNetworkService.perform(requestWith: endpoint, authToken: authToken) { requestResult in
                switch requestResult {
                case .success(let data):
                    let parser = DataParser(jsonDecoder: endpoint.jsonDecoder)
                    do {
                        let decoded: T = try parser.parse(data: data)
                        completion(.success(decoded))
                        return
                    } catch {
                        completion(.failure(.parsingError))
                        return
                    }
                case .failure(let error):
#warning("Discussion: Should also contain refresh api token in order to call retry")
                    completion(.failure(error))
                }
            }
        }
    }
}

private extension ApiNetworkManager {
    func getAuthToken(forced: Bool = false, completionBlock: @escaping (Result<String, ApiNetworkError>) -> Void) {
        if let token = apiStorageService.getToken() {
            completionBlock(.success(token))
            return
        }
        apiNetworkService.perform(requestWith: AuthTokenEndpoints.getAuthToken, authToken: nil) { requestResult in
            switch requestResult {
            case .success(let data):
                let parser = DataParser(jsonDecoder: AuthTokenEndpoints.getAuthToken.jsonDecoder)
                do {
                    let decoded: AuthTokenResponse = try parser.parse(data: data)
                    let token = decoded.apiKey
                    completionBlock(.success(token))
                    return
                } catch {
                    completionBlock(.failure(.parsingError))
                    return
                }
            case .failure(let error):
                completionBlock(.failure(error))
                return
            }
        }
    }
}

extension ApiNetworkManager: ApiReachabilityServiceProtocol {
    func isNetworkReachable() -> Bool {
        apiReachabilityService.isNetworkReachable()
    }
    
    func addListener(_ listener: ApiReachabilityServiceDelegate) {
        apiReachabilityService.addListener(listener)
    }
    
    func removeListener(_ listener: ApiReachabilityServiceDelegate) {
        apiReachabilityService.removeListener(listener)
    }
}
