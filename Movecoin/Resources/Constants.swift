//
//  Constants.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import UIKit

// enum

enum TabBarOptions : Int {
    case Store
    case Wallet
    case Home
    case Statistics
    case Profile
}

// Colors

let ThemeBlueColor : UIColor = hexStringToUIColor(hex: "1d2057")
let ThemeNavigationColor : UIColor = hexStringToUIColor(hex: "2694b0")

let StoreColor : UIColor = hexStringToUIColor(hex: "68cdd9")
let WalletColor : UIColor = hexStringToUIColor(hex: "9c78fc")
let HomeColor : UIColor = hexStringToUIColor(hex: "ff7f9b")
let StatisticsColor : UIColor = hexStringToUIColor(hex: "a6d15d")
let ProfileColor : UIColor = hexStringToUIColor(hex: "4c9ee8")

// Constant Keys

let kIsLogedIn = "isLogin"
