//
//  UserPostSectionViewModel.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation

class UserPostSectionViewModel {
    
    var section: UserPostSection
    var userPostSectionItems: [UserPostSectionItem]
    
    init(section: UserPostSection = .userPosts, userPostSectionItems: [UserPostSectionItem]) {
        self.section = section
        self.userPostSectionItems = userPostSectionItems
    }
    
}
