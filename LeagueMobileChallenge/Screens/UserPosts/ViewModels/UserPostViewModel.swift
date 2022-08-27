//
//  UserPostViewModel.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation

protocol UserPostProtocol {
    var imageURL: URL? { get }
    var title: String { get }
    var subtitle: String { get }
    var body: String { get }
}

struct UserPostViewModel {
    
    let user: UserResponse
    let userPost: PostResponse
    
    init(user: UserResponse, userPost: PostResponse) {
        self.user = user
        self.userPost = userPost
    }
}

extension UserPostViewModel: UserPostProtocol {
    var imageURL: URL? {
        URL(string: user.avatar)
    }
    
    var title: String {
        user.name
    }
    
    var subtitle: String {
        userPost.title
    }
    
    var body: String {
        userPost.body
    }
}

extension UserPostViewModel: Hashable {
    var uuid: String {
        String(user.id) + "_" + String(userPost.id)
    }
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(uuid)
    }
    
    public static func == (lhs: UserPostViewModel, rhs: UserPostViewModel) -> Bool {
      lhs.uuid == rhs.uuid
    }
}
