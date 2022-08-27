//
//  UserPostsViewModel.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation

protocol UserPostsCollectionViewModelProtocol {
    func setDelegate(_ delegate: UserPostsCollectionViewModelDelegate)
    func fetchData()
    func data() -> [UserPostSectionViewModel]
}

protocol UserPostsCollectionViewModelDelegate: AnyObject {
    func reloadData()
}

class UserPostsCollectionViewModel {
    private var errorSection: UserPostSectionViewModel = {
        UserPostSectionViewModel(userPostSectionItems: [UserPostSectionItem.error()])
    }()
    
    private var emptySection: UserPostSectionViewModel = {
        UserPostSectionViewModel(userPostSectionItems: [UserPostSectionItem.empty()])
    }()
    
    private var loadingSection: UserPostSectionViewModel = {
        UserPostSectionViewModel(userPostSectionItems: UserPostSectionItem.loadingItemsViewModel)
    }()
    
    private let networkManager: ApiNetworkManagerProtocol
    unowned private var delegate: UserPostsCollectionViewModelDelegate?
    private let newtworkQueue = DispatchQueue.init(label: "com.LeagueMobileChallenge.Networking", attributes: .concurrent)
    private let networkDispatchGroup = DispatchGroup()
    private lazy var _data = [emptySection] {
        didSet {
            self.delegate?.reloadData()
        }
    }
    
    private var isLoading: Bool {
        if case UserPostSectionItem.loading(_) = _data.first!.userPostSectionItems.first! {
            return true
        }
        return false
    }
    
    init(networkManager: ApiNetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension UserPostsCollectionViewModel: UserPostsCollectionViewModelProtocol {
    func setDelegate(_ delegate: UserPostsCollectionViewModelDelegate) {
        self.delegate = delegate
    }
    
    func fetchData() {
        guard isLoading == false else {
            return
        }
        updateData(data: loadingSection)

        var usersResult: Result<[UserResponse], ApiNetworkError>?
        var postsResult: Result<[PostResponse], ApiNetworkError>?
        
        //todo: updare ui
        networkDispatchGroup.enter()
        newtworkQueue.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.networkManager.perform(requestWith: DataFeedEndpoints.posts)
            { [weak self] (result: Result<[PostResponse], ApiNetworkError>) in
                postsResult = result
                self?.networkDispatchGroup.leave()
            }
        }
        
        networkDispatchGroup.enter()
        newtworkQueue.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.networkManager.perform(requestWith: UserEndpoints.users)
            { [weak self] (result: Result<[UserResponse], ApiNetworkError>) in
                usersResult = result
                self?.networkDispatchGroup.leave()
            }
        }
        
        //NOTE: could be extracted into DispatchWorkItem
        networkDispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let postsResult = postsResult,
                  let usersResult = usersResult else {
                strongSelf.updateData(data: strongSelf.errorSection)
                return
            }
            
            guard case let .success(postsResponse) = postsResult,
                  case let .success(usersResponse) = usersResult else {
                strongSelf.updateData(data: strongSelf.errorSection)
                return
            }
            let newData = strongSelf.buildData(posts: postsResponse, users: usersResponse)
            strongSelf.updateData(data: newData)
        }
    }
    
    func data() -> [UserPostSectionViewModel] {
        self._data
    }
    

}

private extension UserPostsCollectionViewModel {
    
    func buildData(posts: [PostResponse], users: [UserResponse]) -> UserPostSectionViewModel {
        var postViewModels = [UserPostSectionItem]()
        for post in posts {
            for user in users {
                if user.id == post.userId {
                    let vm = UserPostViewModel(user: user, userPost: post)
                    postViewModels.append(.userPost(vm))
                    break
                }
            }
        }
        guard !postViewModels.isEmpty else {
            return emptySection
        }
        return UserPostSectionViewModel(userPostSectionItems: postViewModels)
    }
    
    func updateData(data: UserPostSectionViewModel) {
        _data = [data]
    }
}

