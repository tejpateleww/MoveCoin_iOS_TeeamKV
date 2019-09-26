//
//  UtilityClass.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation

extension NSObject {
    static var className : String {
        return String(describing: self)
    }
}
