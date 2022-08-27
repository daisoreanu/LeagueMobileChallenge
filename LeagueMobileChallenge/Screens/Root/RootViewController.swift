//
//  RootViewController.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet private weak var warningViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var childControllersView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let networkManager = ApiNetworkManager()
        networkManager.addListener(self)
        
        let vm = UserPostsCollectionViewModel(networkManager: networkManager)
        let vc = UserPostsCollectionViewController(viewModel: vm)
        let nc = UINavigationController(rootViewController: vc)
        self.add(child: nc, into: childControllersView)
        
//        networkManager.perform(requestWith: DataFeedEndpoints.posts)
//        { (result: Result<[PostResponse], ApiNetworkError>) in
//            switch result {
//            case .success(let posts):
//                print(posts)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//
//        networkManager.perform(requestWith: UserEndpoints.users)
//        { (result: Result<[User], ApiNetworkError>) in
//            switch result {
//            case .success(let posts):
//                print(posts)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
        
    }

}

extension RootViewController: ApiReachabilityServiceDelegate {
    func internetConnectivityChanged(status: ApiReachabilityStatus) {
        print(status.rawValue)
        if status == .unavailable {
            warningViewBottomConstraint.constant = 50
            view.layoutIfNeeded()
        } else {
            warningViewBottomConstraint.constant = -100
            view.layoutIfNeeded()
        }
    }
}
