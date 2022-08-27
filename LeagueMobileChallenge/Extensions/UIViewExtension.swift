//
//  UIViewExtension.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation
import UIKit

extension UIView {
    
    func pinAllEdges(toFill parent: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: parent.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: 0).isActive = true
    }
    
    // Corner radius
    @IBInspectable var cornerRadius: Bool {
        get {
            return self.layer.cornerRadius != 0.0
        }
        
        set {
            self.layer.cornerRadius = self.layer.frame.size.width / 2.0
        }
    }
    
    
}

