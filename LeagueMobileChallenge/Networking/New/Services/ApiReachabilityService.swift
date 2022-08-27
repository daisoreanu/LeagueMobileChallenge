//
//  ApiReachabilityService.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation
import Reachability

enum ApiReachabilityStatus: String {
    case unkown = "Unknown connection status"
    case cellular = "Cellular connection"
    case wifi = "WiFi connection"
    case unavailable = "No internet connection"
    
    var isReachable: Bool {
        return self != .unavailable
    }
}

protocol ApiReachabilityServiceProtocol {
    func isNetworkReachable() -> Bool
    func addListener(_ listener: ApiReachabilityServiceDelegate)
    func removeListener(_ listener: ApiReachabilityServiceDelegate)
}

protocol ApiReachabilityServiceDelegate: AnyObject {
    func internetConnectivityChanged(status: ApiReachabilityStatus)
}

class ApiReachabilityService {
    
    private let reachability = try! Reachability()
    private var delegates = [ApiReachabilityServiceDelegate]()
    private var reachabilityStatus = ApiReachabilityStatus.unkown {
        didSet {
            if oldValue != reachabilityStatus {
                publishNetworkUpdate(status: reachabilityStatus)
            }
        }
    }
    
    init() {
        setupInitialStatus()
        subscribeForNotifications()
    }
    
    deinit {
        reachability.stopNotifier()
    }
    
}

private extension ApiReachabilityService {
    func setupInitialStatus() {
        guard reachability.connection != .unavailable else {
            reachabilityStatus = .unavailable
            return
        }
        if reachability.connection == .wifi {
            reachabilityStatus = .wifi
        } else {
            reachabilityStatus = .cellular
        }
    }
    func subscribeForNotifications() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                self.reachabilityStatus = .wifi
            } else {
                self.reachabilityStatus = .cellular
            }
        }
        reachability.whenUnreachable = { _ in
            self.reachabilityStatus = .unavailable
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func publishNetworkUpdate(status: ApiReachabilityStatus) {
        DispatchQueue.main.async {
            self.delegates.forEach { delegate in
                delegate.internetConnectivityChanged(status: status)
            }
        }
    }
}

extension ApiReachabilityService: ApiReachabilityServiceProtocol {
    func isNetworkReachable() -> Bool {
        return reachabilityStatus != .unavailable
    }
    
    func addListener(_ listener: ApiReachabilityServiceDelegate) {
        delegates.append(listener)
    }
    
    func removeListener(_ listener: ApiReachabilityServiceDelegate) {
        delegates = delegates.filter { delegate in
            delegate !== listener
        }
    }
}
