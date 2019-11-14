//
//  Constants.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import UIKit


// Constants

let windowWidth: CGFloat = CGFloat(UIScreen.main.bounds.size.width)
let windowHeight: CGFloat = CGFloat(UIScreen.main.bounds.size.height)
let screenHeightDeveloper : Double = 812
let screenWidthDeveloper : Double = 375

let kAPPVesion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

let AppDelegateShared = UIApplication.shared.delegate as! AppDelegate

typealias onCompletion = () -> Void


// Colors

let ThemeBlueColor : UIColor = hexStringToUIColor(hex: "1d2057")
let ThemeNavigationColor : UIColor = hexStringToUIColor(hex: "2694b0")

let StoreColor : UIColor = hexStringToUIColor(hex: "68cdd9")
let WalletColor : UIColor = hexStringToUIColor(hex: "9c78fc")
let HomeColor : UIColor = hexStringToUIColor(hex: "ff7f9b")
let StatisticsColor : UIColor = hexStringToUIColor(hex: "a6d15d")
let ProfileColor : UIColor = hexStringToUIColor(hex: "4c9ee8")

let TransparentColor : UIColor = UIColor.init(white: 1.0, alpha: 0.23)

// Constant Keys

let kAppName = "MoveCoins"

// User Defaults Keys

//let kIsLogedIn = "isLogin"
//let kDeviceToken = "DeviceToken"
//let kUserProfile = "userProfile"
//let kX_API_KEY = "x-api-key"
//let kIsFirstTimeLocationUpdate = "isFirstTimeLocationUpdate"
