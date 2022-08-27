//
//  InstructionItemViewModel.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation
import UIKit

class InstructionItemViewModel {
    let id = UUID()
    let body: String
    var image: UIImage? {
        UIImage(named: imagePath)
    }
    private let imagePath: String
    
    init(body: String, imagePath: String) {
        self.body = body
        self.imagePath = imagePath
    }
}

extension InstructionItemViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: InstructionItemViewModel, rhs: InstructionItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
