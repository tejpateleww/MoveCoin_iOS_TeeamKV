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

struct SocketApiKeys {
    
    static let kSocketBaseURL = "http://www.movecoins.net:8080/"
    static let kConnectUser = "connect_user"
    static let kUpdateUserLocation = "update_user_location"
    
    static let KUserId = "user_id"
    static let kLat = "lat"
    static let kLng = "lng"
}

enum ApiKey: String{
    case Init = "user/init/"
    case login = "user/login"
    case socialMedia = "user/social_login"
    case appleDetails = "user/apple_details"
    case logout = "user/logout/"
    case otp = "user/register_otp"
    case register = "user/register"
    case changePassword = "user/change_password"
    case forgotPassword = "user/forgot_password"
    case profileData = "user/profile_data"
    case profileUpdate = "user/profile_update"
    case userDetails = "user/detail_user"
    case updateSteps = "User/update_steps/"
    case stepsHistory = "User/steps_history/"
    case coinsEarning = "User/coins_earning_history/"
    case addCard = "User/add_new_card"
    case cardList = "user/cards/"
    case removeCard = "user/remove_card/"
    case notification = "user/notification/"
    case updateLanguage = "user/update_language/"
    case accountPrivacy = "user/account_privacy/"
    case policyHelpTerm = "user/policy_help_terms"
    
    case productsList = "Products/product_list"
    case productDetails = "Products/product_detail"
    
    case nearByUsers = "friends/nearbyuser"
    case nearByUsersDetail = "friends/nearbyuser_details"
    case inviteFriends = "Friends/friends_invite"
    case friendRequest = "Friends/friend_request"
    case actionOnFriendRequest = "Friends/action_on_friend_request"
    case unfriend = "Friends/unfriend"
    case coinsHistory = "Friends/coins_history/"
    case friendList = "Friends/list_friend"
    case transferCoins = "Friends/coins_transfer"
    case sendMessage = "Friends/send_message/"
    case chatList = "friends/chat_list"
    case chatClear = "friends/clear_chat"
    case chatHistory = "friends/old_chat_history"
    
    case addSeller = "Seller/add_seller"
    
//    case placeOrder = "order/place_order"
    case placeOrder = "order/add_order"
    case purchaseHistory = "Order/purchase_history"
}
