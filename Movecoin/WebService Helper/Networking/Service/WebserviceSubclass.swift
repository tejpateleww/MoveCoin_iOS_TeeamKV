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
//    class func initApi( strURL : String  ,completion: @escaping CompletionResponse ) {
//        WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)
//    }
    
    class func getAPI( strURL : String  ,completion: @escaping CompletionResponse ) {
           WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)
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
        }else{
            WebService.shared.requestMethod(api: .profileUpdate, httpMethod: .post, parameters: params, completion: completion)
        }
    }

    class func Logout( strURL : String  ,completion: @escaping CompletionResponse ){
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.logout.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func userDetails( userDetailModel : UserDetailModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = userDetailModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .userDetails, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func addCard( addCardModel : AddCardModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = addCardModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .addCard, httpMethod: .post, parameters: params, completion: completion)
    }
 
}


class ProductWebserviceSubclass
{
    class func productsList( strURL : String  ,completion: @escaping CompletionResponse ){
        WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)
    }
    
    class func productDetails( productDetailModel : ProductDetailModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = productDetailModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .productDetails, httpMethod: .post, parameters: params, completion: completion)
    }
}

class FriendsWebserviceSubclass
{
    class func inviteFriends( inviteFrinedsModel : InviteFriendsModel  ,completion: @escaping CompletionResponse ) {
        let  params = inviteFrinedsModel.generatPostParams()
        WebService.shared.requestMethod(api: .inviteFriends, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func friendRequest( frinedRequestModel : FriendRequestModel  ,completion: @escaping CompletionResponse ) {
        let  params = frinedRequestModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .friendRequest, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func actionOnFriendRequest( actionFrinedRequestModel : ActionOnFriendRequestModel  ,completion: @escaping CompletionResponse ) {
        let  params = actionFrinedRequestModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .actionOnFriendRequest, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func unfriend( unfrinedModel : UnfriendModel  ,completion: @escaping CompletionResponse ) {
        let  params = unfrinedModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .unfriend, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func friendsList( frinedListModel : FriendListModel  ,completion: @escaping CompletionResponse ) {
        let  params = frinedListModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .friendList, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func chatList( chatListModel : ChatListModel  ,completion: @escaping CompletionResponse ) {
        let  params = chatListModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .chatList, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func chatHistory( chatHistoryModel : ChatHistoryModel  ,completion: @escaping CompletionResponse ) {
        let  params = chatHistoryModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .chatHistory, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func sendMessage( sendMessageModel : SendMessage  ,completion: @escaping CompletionResponse ) {
        let  params = sendMessageModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .sendMessage, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func transferCoins( transferCoinModel : TransferCoinsModel  ,completion: @escaping CompletionResponse ) {
        let  params = transferCoinModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .transferCoins, httpMethod: .post, parameters: params, completion: completion)
    }
}

class SellerWebserviceSubclass
{
    class func becomeSeller( sellerModel : BecomeSellerModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = sellerModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .addSeller, httpMethod: .post, parameters: params, completion: completion)
    }
}

class OrderWebserviceSubclass
{
    class func placeOrder( orderModel : PlaceOrder  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = orderModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .placeOrder, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func purchaseHistory( purchaseHistoryModel : PurchaseHistory  ,completion: @escaping CompletionResponse ) {
        let  params = purchaseHistoryModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .purchaseHistory, httpMethod: .post, parameters: params, completion: completion)
    }
}
