//
//  JoinCrowdTextField.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/18/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation
import UIKit

class JoinCrowdTextField: UITextField {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint.init(x: self.center.x - 5.0, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint.init(x: self.center.x + 5.0, y: self.center.y))
        layer.add(animation, forKey: "position")
    }
    
}
