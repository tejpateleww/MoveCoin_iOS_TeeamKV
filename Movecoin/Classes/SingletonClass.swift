//
//  SingletonClass.swift
//  Movecoins
//
//  Created by eww090 on 11/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import CoreLocation

class SingletonClass: NSObject {
    
    static let SharedInstance = SingletonClass()
    
//    var ReferalCode:String = "8545-fhgd-6548-skdjh"
    
    var myCurrentLocation : CLLocation?
   
    var DeviceToken :String = "123123123123123"
    var userData : UserData?
    var productType : [Category]?
    var userInfo : [String: Any]?
    
//    var todaysStepCount : NSNumber?
    var todaysStepCount : Int?
    var lastUpdatedDtae : Date?
    
    func singletonClear() {
        self.userData = nil
    }
}

