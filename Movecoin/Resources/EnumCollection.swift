//
//  EnumCollection.swift
//  Movecoins
//
//  Created by eww090 on 31/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation

enum TabBarOptions : Int {
    case Store = 0
    case Wallet
    case Home
    case Statistics
    case Profile
}

enum Membership : Int {
    case Silver = 1
    case Gold
    case Platinum
}

enum FriendsStatus : String {
    case RequestPendding = "Requested"
    case RecommendedFriend = "Recommended"
    case NotRegistedFriend = "Not Registered"
    case AlreadyFriend = "Already Friend"
}

enum FriendsList  {
    case TransferCoins
    case Unfriend
    case NewChat
}


enum WalletViewType  {
    case Wallet
    case Coins
}

enum CoinsTransferType : String {
    case Send 
    case Receive
}

enum PurchaseDetailViewType  {
    case Purchase
    case History
}
enum SettingsOptions : Int {
    case Notification = 0
    case AccountPrivacy
    case EditProfile
    case ChangePassword
    case PurchaseHistory
    case AddCard
    case TermsAndConditions
    case Help
    case RateApp
    case PrivacyPolicy
    case Support
    case Language
}

enum FontBook: String {
    
    case Light = "Cairo-Light"
    case Regular = "Cairo-Regular"
    case SemiBold = "Cairo-SemiBold"
    case Bold = "Cairo-Bold"
    case Black = "Cairo-Black"
    case ExtraLight = "Cairo-ExtraLight"
    
    func of(size: CGFloat) -> UIFont {
        return UIFont(name:self.rawValue, size:size)!
    }

    func staticFont(Size:CGFloat) -> UIFont{
        return UIFont(name:self.rawValue,size:Size)!
    }
}

enum UserDefaultKeys : CaseIterable {
    static let kIsLogedIn = "isLogin"
    static let kDeviceToken = "DeviceToken"
    static let kUserProfile = "userProfile"
    static let kX_API_KEY = "x-api-key"
    static let kIsFirstTimeLocationUpdate = "isFirstTimeLocationUpdate"
    
    //    static let LoginResponse = "LoginResponse"
    //    static let IsLogin = "IsLogin"
    //    static let EmailNotification = "EmailNotification"
    //    static let SmsNotification = "SmsNotification"
    //    static let PushNotification = "PushNotification"
}

enum DateFomateKeys : CaseIterable {
    static let displayDate = "dd-MM-yyyy"
    static let displayDateTime = "dd-MM-yyyy HH:mm"
    static let displayFullDate = "dd-MMM-yyyy HH:mm"
    static let apiDOB = "yyyy-MM-dd"
    static let api = "yyyy-MM-dd HH:mm:ss"
    
    
//    let dateFormateToDisplay = "dd-MM-yyyy"
//    let dateFormateOfApi = "yyyy-MM-dd"
}
