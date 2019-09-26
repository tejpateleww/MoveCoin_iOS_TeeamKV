//
//  UIview + Extension.swift
//  Movecoin
//
//  Created by eww090 on 12/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
