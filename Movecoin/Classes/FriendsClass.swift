//
//  FriendsClass.swift
//  Movecoins
//
//  Created by eww090 on 09/12/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation


class PhoneModel : Codable, Comparable {
    
    var name: String = ""
    var number: String = ""
    
    init(name: String, number: String){
        self.name = name
        self.number = number
    }
    
    static func < (lhs: PhoneModel, rhs: PhoneModel) -> Bool {
        return lhs.name.capitalizingFirstLetter() < rhs.name.capitalizingFirstLetter()
    }
    
    static func == (lhs: PhoneModel, rhs: PhoneModel) -> Bool {
         return lhs.name == rhs.name
    }
}
