//
//  ApiPaths.swift
//  Movecoins
//
//  Created by eww090 on 11/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation

typealias NetworkRouterCompletion = ((Data?,[String:Any]?, Bool) -> ())

enum NetworkEnvironment: String {
    
//    case liveBaseUrl = "https://www.peppea.com/panel/api/customer_api/"
    
    case developmentBaseUrl = "https://www.movecoins.net/admin/api/"
    case imageURL = "https://www.movecoins.net/admin/"
    case galleryURL = "https://www.movecoins.net/admin/assets/images/products/"
    
    static var baseURL : String{
        return NetworkEnvironment.environment.rawValue
    }
    
    static var baseImageURL : String{
        return NetworkEnvironment.imageURL.rawValue
    }
    
    static var baseGalleryURL : String{
        return NetworkEnvironment.galleryURL.rawValue
    }
    
    static var headers : [String:String]
    {
        
        if UserDefaults.standard.object(forKey: UserDefaultKeys.kIsLogedIn) != nil {
            
            if UserDefaults.standard.object(forKey: UserDefaultKeys.kIsLogedIn) as? Bool == true {
                
                if let key = UserDefaults.standard.value(forKey: UserDefaultKeys.kX_API_KEY) {
                    print("x-api-key : \(key)")
                    return ["key":kKey, "x-api-key": key as! String]
                }else{
                    return ["key":kKey]
                }
            }
        }
        return ["key":kKey]
    }
    
    static var environment: NetworkEnvironment{
        //Set environment Here
        
//        #if DEBUG
        return .developmentBaseUrl
//        #else
//        return .liveBaseUrl
//        #endif
    }
    
    static var token: String{
        return "dhuafidsuifunabneufjubefg"
    }
}

enum ApiKey: String{
    case Init = "user/init/"
    case login = "user/login"
    case logout = "user/logout/"
    case otp = "user/register_otp"
    case register = "user/register"
    case changePassword = "user/change_password"
    case forgotPassword = "user/forgot_password"
    case profileUpdate = "user/profile_update"
    case userDetails = "user/detail_user"
    case updateSteps = "User/update_steps/"
    case stepsHistory = "User/steps_history/"
    case coinsEarning = "User/coins_earning_history/"
    case addCard = "User/add_new_card"
    case cardList = "user/cards/"
    case removeCard = "user/remove_card/"
    case notification = "user/notification/"
    case accountPrivacy = "user/account_privacy/"
    
    case productsList = "Products/product_list"
    case productDetails = "Products/product_detail"
    
    case inviteFriends = "Friends/friends_invite"
    case friendRequest = "Friends/friend_request"
    case actionOnFriendRequest = "Friends/action_on_friend_request"
    case unfriend = "Friends/unfriend"
    case coinsHistory = "Friends/coins_history/"
    case friendList = "Friends/list_friend"
    case transferCoins = "Friends/coins_transfer" 
    
    case addSeller = "Seller/add_seller"
    
    case placeOrder = "order/place_order"
    case purchaseHistory = "Order/purchase_history"
}
