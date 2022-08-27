//
//  UserPostsSection.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation

enum UserPostSection: Hashable {
    case userPosts
}

enum UserPostSectionItem: Hashable {
    case userPost(UserPostViewModel)
    case error(InstructionItemViewModel = errorItemViewModel) //🤕
    case empty(InstructionItemViewModel = emptyItemViewModel) //📭
    case loading(UUID)
}

extension UserPostSectionItem {
    static var loadingItemsViewModel: [UserPostSectionItem] {
        return Array(repeatingExpression: UserPostSectionItem.loading(UUID()), count: 10)
    }
    
    static var emptyItemViewModel: InstructionItemViewModel {
        InstructionItemViewModel(body: "There aren't any results for now. Try again later.",
                                 imagePath: "no_results_ic")
    }
    
    static var errorItemViewModel: InstructionItemViewModel {
        InstructionItemViewModel(body: "Something went wrong. Keep trying.",
                                 imagePath: "connection_error_ic")
    }
}
