//
//  WebserviceSubclass.swift
//  Movecoins
//
//  Created by eww090 on 11/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation


class UserWebserviceSubclass
{
    class func initApi( strURL : String  ,completion: @escaping CompletionResponse ) {
        WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)//requestMethod(api: .update, httpMethod: .get, parameters: strType, completion: completion)
    }
    
    class func signup( signupModel : SignupModel, image: UIImage?, imageParamName: String? = "ProfilePicture", completion: @escaping CompletionResponse ) {
        let  params : [String:String] = signupModel.generatPostParams() as! [String : String]
        if let img = image, let imgName = imageParamName {
             WebService.shared.postDataWithImage(api: .register, parameter: params, image: img, imageParamName: imgName, completion: completion)
        }else {
             WebService.shared.requestMethod(api: .register, httpMethod: .post, parameters: params, completion: completion)
        }
    }
    
    class func otpRequest( signupModel : SignupModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = signupModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .otp, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func otpSendAgain( otpRequestModel : OTPrequestModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = otpRequestModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .otp, httpMethod: .post, parameters: params, completion: completion)
    }

    class func login( loginModel : LoginModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = loginModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .login, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func forgotPassword( ForgotPasswordModel : ForgotPassword  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = ForgotPasswordModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .forgotPassword, httpMethod: .post, parameters: params, completion: completion)
    }

    class func changePassword( ChangePasswordModel : ChangePassword  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = ChangePasswordModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .changePassword, httpMethod: .post, parameters: params, completion: completion)
    }

    class func editProfile( editProfileModel : EditProfileModel, image: UIImage?, imageParamName: String? = "ProfilePicture", completion: @escaping CompletionResponse ) {
        let  params : [String:String] = editProfileModel.generatPostParams() as! [String : String]
        if let img = image, let imgName = imageParamName {
            WebService.shared.postDataWithImage(api: .profileUpdate, parameter: params, image: img, imageParamName: imgName, completion: completion)
        }else {
            WebService.shared.requestMethod(api: .profileUpdate, httpMethod: .post, parameters: params, completion: completion)
        }
    }

    class func Logout( strURL : String  ,completion: @escaping CompletionResponse ){
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.logout.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }

//    class func checkPromocodeService(Promocode : CheckPromocode  ,completion: @escaping CompletionResponse ) {
//        let  params : [String:String] = Promocode.generatPostParams() as! [String : String]
//        WebService.shared.requestMethod(api: .checkPromocode, httpMethod: .post, parameters: params, completion: completion)
//    }
    
}
