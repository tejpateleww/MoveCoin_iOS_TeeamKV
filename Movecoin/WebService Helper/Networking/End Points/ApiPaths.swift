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
    
    case developmentBaseUrl = "http://15.206.43.169/api/"
    

    case imageURL = "http://15.206.43.169/assets/images/"
    
    static var baseURL : String{
        return NetworkEnvironment.environment.rawValue
    }
    
    static var baseImageURL : String{
        return NetworkEnvironment.imageURL.rawValue
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
}