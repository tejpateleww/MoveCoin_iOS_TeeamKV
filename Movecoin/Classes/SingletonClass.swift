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
   
    var DeviceToken :String = ""
    var lastUpdatedStepsAt : String?
    var serverTime : String?
    var facebookID : String?
    var userData : UserData?
    var productType : [Category]?
    var coinsDiscountRelation : CoinsDiscountRelation?
    var userInfo : [String: Any]?
    
//    var todaysStepCount : NSNumber?
    var todaysStepCountInitial : Int?
    var todaysStepCount : String?
    var lastUpdatedDtae : Date?
    var initResponse : InitResponse?
    
    func singletonClear() {
        self.userData = nil
    }
}

