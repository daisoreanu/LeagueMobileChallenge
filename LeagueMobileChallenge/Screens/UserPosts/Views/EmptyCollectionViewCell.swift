//
//  EmptyCollectionViewCell.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import UIKit

class EmptyCollectionViewCell: UICollectionViewCell {

    class var identifier: String {
        String(describing: EmptyCollectionViewCell.self)
    }
    
    class var cellSize: CGSize {
        let height: CGFloat = 190.0
        let width: CGFloat = UIScreen.main.currentMode!.size.width
        return CGSize(width: width, height: height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
