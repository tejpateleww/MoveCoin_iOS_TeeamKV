//
//  UINavigationController + Extensions.swift
//  Movecoin
//
//  Created by eww090 on 12/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    public func hasViewController(ofKind kind: AnyClass) -> UIViewController? {
        return self.viewControllers.first(where: {$0.isKind(of: kind)})
    }
    
   
}
