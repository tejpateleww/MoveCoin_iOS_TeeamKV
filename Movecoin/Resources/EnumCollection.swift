//
//  EnumCollection.swift
//  Movecoins
//
//  Created by eww090 on 31/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation

enum StepsPermission : String {
    case HealthKit = "HeakthKit"
    case MotionAndFitness = "MotionAndFitness"
}

enum PaymentStatus : String {
    case Success = "Completed"
    case Failed = "Cancel"
    case Pending = "Pending"
    case Placed = "Placed"

}

enum TabBarOptions : Int {
    case Store = 0
    case Challenge
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

enum RequestType : String {
    case Facebook = "0"
    case Contacts = "1"
    case Search = "2"
    case Map = "3"
    
    func requestTypeString() -> String {
        switch self {
        case .Facebook:
            return "Facebook".localized
        case .Contacts:
            return "Contacts".localized
        case .Search:
            return "Search".localized
        case .Map:
            return "Map".localized
        }
    }
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
    case BlockList
    case Block
}

enum BarChartTitles : Int {
    case Weekly = 0
    case Monthly
    case Yearly
}

enum WalletViewType  {
    case Wallet
    case Coins
}

enum CoinsTransferType : String {
    case Send 
    case Receive
    case Redeem
    case RedeemOffer
}

enum PurchaseDetailViewType  {
    case Purchase
    case History
}

enum SettingsOptions : String {
    case Notification = "Notification"
    case AccountPrivacy = "Account Privacy"
    case EditProfile = "Edit Profile"
//    case ChangePassword
    case PurchaseHistory = "Purchase History"
    case TotalRedeem = "Total Redeem"
    case BlockList = "Block List"
//    case AddCard
    case Help = "Help/Support"
    case TermsAndConditions = "Terms and Conditions"
    case PrivacyPolicy = "Privacy Policy"
    case Language = "Language"
    case RateApp = "Rate this app"
}

enum DocumentType : String {
    case TermsAndCondition = "Terms and Conditions"
    case PrivacyPolicy = "Privacy Policy"
    case Help = "Help/Support"
}

enum FontBook: String {
    
    case Light = "DINNextLTW23-Light"
    case Regular = "DINNextLTW23-Regular"
    case SemiBold = "DINNextLTW23-Black"
//    case Bold = "DINAlternate-Bold"
//    case Black = "Cairo-Black"
//    case ExtraLight = "Cairo-ExtraLight"
    
    func of(size: CGFloat) -> UIFont {
        return UIFont(name:self.rawValue, size:size)!
    }

    func staticFont(Size:CGFloat) -> UIFont {
        return UIFont(name:self.rawValue,size:Size)!
    }
}

enum UserDefaultKeys : CaseIterable {
    static let kIsOnBoardLaunched = "isOnBoardLaunched"
    static let kIsLogedIn = "isLogin"
    static let kDeviceToken = "DeviceToken"
    static let kUserProfile = "userProfile"
    static let kX_API_KEY = "x-api-key"
    static let kIsFirstTimeLocationUpdate = "isFirstTimeLocationUpdate"
    static let kFacebookID = "FacebookID"
    static let kFriendRequestCount = "FriendRequestCount"
}

enum DateFomateKeys : CaseIterable {
    static let displayDate = "dd-MM-yyyy"
    static let displayDateTime = "dd-MM-yyyy HH:mm"
    static let displayFullDate = "dd-MMM-yyyy HH:mm"
    static let apiDOB = "yyyy-MM-dd"
    static let api = "yyyy-MM-dd HH:mm:ss"
    static let challengDateFormat = "MMMM dd,yyyy"
    static let offerPurchased = "MMMM dd,yyyy hh:mm a"
    
//    let dateFormateToDisplay = "dd-MM-yyyy"
//    let dateFormateOfApi = "yyyy-MM-dd"
}
