//
//  UIViewControllerExtension.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation
import UIKit

extension UIViewController {
    var backgroundColor: UIColor? {
        return self.view.backgroundColor
    }
    
    func add(child vc: UIViewController, into view: UIView) {
        self.addChild(vc)
        view.addSubview(vc.view)
        vc.view.pinAllEdges(toFill: view)
        vc.didMove(toParent: self)
    }
    
    func removeChild(from view: UIView) {
        self.willMove(toParent: nil)
        view.removeFromSuperview()
        self.removeFromParent()
    }
}
