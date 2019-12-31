//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 13, 2019

import Foundation
import SwiftyJSON


class UserData : Codable {
    
    var accountPrivacy : String!
    var coins : String!
    var createdDate : String!
    var dateOfBirth : String!
    var deviceToken : String!
    var deviceType : String!
    var email : String!
    var friends : String!
    var fullName : String!
    var gender : String!
    var height : String!
    var iD : String!
    var inviteFriends : String!
    var latitude : String!
    var longitude : String!
    var membership : String!
    var memberType : String!
    var nickName : String!
    var notification : String!
    var password : String!
    var phone : String!
    var profilePicture : String!
    var referBy : String!
    var referralCode : String!
    var rememberToken : String!
    var socialID : String!
    var socialType : String!
    var status : String!
    var steps : String!
    var trash : String!
    var updatedDate : String!
    var userName : String!
    var walletBalance : String!
    var weight : String!
    
    init(){
        
    }

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        accountPrivacy = json["AccountPrivacy"].stringValue
        coins = json["Coins"].stringValue
        createdDate = json["CreatedDate"].stringValue
        dateOfBirth = json["DateOfBirth"].stringValue
        deviceToken = json["DeviceToken"].stringValue
        deviceType = json["DeviceType"].stringValue
        email = json["Email"].stringValue
        friends = json["Friends"].stringValue
        fullName = json["FullName"].stringValue
        gender = json["Gender"].stringValue
        height = json["Height"].stringValue
        iD = json["ID"].stringValue
        inviteFriends = json["Invite_friends"].stringValue
        latitude = json["Latitude"].stringValue
        longitude = json["Longitude"].stringValue
        membership = json["Membership"].stringValue
        memberType = json["MemberType"].stringValue
        nickName = json["NickName"].stringValue
        notification = json["Notification"].stringValue
        password = json["Password"].stringValue
        phone = json["Phone"].stringValue
        profilePicture = json["ProfilePicture"].stringValue
        referBy = json["ReferBy"].stringValue
        referralCode = json["ReferralCode"].stringValue
        rememberToken = json["RememberToken"].stringValue
        socialID = json["SocialID"].stringValue
        socialType = json["SocialType"].stringValue
        status = json["Status"].stringValue
        steps = json["Steps"].stringValue
        trash = json["Trash"].stringValue
        updatedDate = json["UpdatedDate"].stringValue
        userName = json["UserName"].stringValue
        walletBalance = json["WalletBalance"].stringValue
        weight = json["Weight"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if accountPrivacy != nil{
            dictionary["AccountPrivacy"] = accountPrivacy
        }
        if coins != nil{
            dictionary["Coins"] = coins
        }
        if createdDate != nil{
            dictionary["CreatedDate"] = createdDate
        }
        if dateOfBirth != nil{
            dictionary["DateOfBirth"] = dateOfBirth
        }
        if deviceToken != nil{
            dictionary["DeviceToken"] = deviceToken
        }
        if deviceType != nil{
            dictionary["DeviceType"] = deviceType
        }
        if email != nil{
            dictionary["Email"] = email
        }
        if friends != nil{
            dictionary["Friends"] = friends
        }
        if fullName != nil{
            dictionary["FullName"] = fullName
        }
        if gender != nil{
            dictionary["Gender"] = gender
        }
        if height != nil{
            dictionary["Height"] = height
        }
        if iD != nil{
            dictionary["ID"] = iD
        }
        if inviteFriends != nil{
            dictionary["Invite_friends"] = inviteFriends
        }
        if latitude != nil{
            dictionary["Latitude"] = latitude
        }
        if longitude != nil{
            dictionary["Longitude"] = longitude
        }
        if membership != nil{
            dictionary["Membership"] = membership
        }
        if memberType != nil{
            dictionary["MemberType"] = memberType
        }
        if nickName != nil{
            dictionary["NickName"] = nickName
        }
        if notification != nil{
            dictionary["Notification"] = notification
        }
        if password != nil{
            dictionary["Password"] = password
        }
        if phone != nil{
            dictionary["Phone"] = phone
        }
        if profilePicture != nil{
            dictionary["ProfilePicture"] = profilePicture
        }
        if referBy != nil{
            dictionary["ReferBy"] = referBy
        }
        if referralCode != nil{
            dictionary["ReferralCode"] = referralCode
        }
        if rememberToken != nil{
            dictionary["RememberToken"] = rememberToken
        }
        if socialID != nil{
            dictionary["SocialID"] = socialID
        }
        if socialType != nil{
            dictionary["SocialType"] = socialType
        }
        if status != nil{
            dictionary["Status"] = status
        }
        if steps != nil{
            dictionary["Steps"] = steps
        }
        if trash != nil{
            dictionary["Trash"] = trash
        }
        if updatedDate != nil{
            dictionary["UpdatedDate"] = updatedDate
        }
        if userName != nil{
            dictionary["UserName"] = userName
        }
        if walletBalance != nil{
            dictionary["WalletBalance"] = walletBalance
        }
        if weight != nil{
            dictionary["Weight"] = weight
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        accountPrivacy = aDecoder.decodeObject(forKey: "AccountPrivacy") as? String
        coins = aDecoder.decodeObject(forKey: "Coins") as? String
        createdDate = aDecoder.decodeObject(forKey: "CreatedDate") as? String
        dateOfBirth = aDecoder.decodeObject(forKey: "DateOfBirth") as? String
        deviceToken = aDecoder.decodeObject(forKey: "DeviceToken") as? String
        deviceType = aDecoder.decodeObject(forKey: "DeviceType") as? String
        email = aDecoder.decodeObject(forKey: "Email") as? String
        friends = aDecoder.decodeObject(forKey: "Friends") as? String
        fullName = aDecoder.decodeObject(forKey: "FullName") as? String
        gender = aDecoder.decodeObject(forKey: "Gender") as? String
        height = aDecoder.decodeObject(forKey: "Height") as? String
        iD = aDecoder.decodeObject(forKey: "ID") as? String
        inviteFriends = aDecoder.decodeObject(forKey: "Invite_friends") as? String
        latitude = aDecoder.decodeObject(forKey: "Latitude") as? String
        longitude = aDecoder.decodeObject(forKey: "Longitude") as? String
        membership = aDecoder.decodeObject(forKey: "Membership") as? String
        memberType = aDecoder.decodeObject(forKey: "MemberType") as? String
        nickName = aDecoder.decodeObject(forKey: "NickName") as? String
        notification = aDecoder.decodeObject(forKey: "Notification") as? String
        password = aDecoder.decodeObject(forKey: "Password") as? String
        phone = aDecoder.decodeObject(forKey: "Phone") as? String
        profilePicture = aDecoder.decodeObject(forKey: "ProfilePicture") as? String
        referBy = aDecoder.decodeObject(forKey: "ReferBy") as? String
        referralCode = aDecoder.decodeObject(forKey: "ReferralCode") as? String
        rememberToken = aDecoder.decodeObject(forKey: "RememberToken") as? String
        socialID = aDecoder.decodeObject(forKey: "SocialID") as? String
        socialType = aDecoder.decodeObject(forKey: "SocialType") as? String
        status = aDecoder.decodeObject(forKey: "Status") as? String
        steps = aDecoder.decodeObject(forKey: "Steps") as? String
        trash = aDecoder.decodeObject(forKey: "Trash") as? String
        updatedDate = aDecoder.decodeObject(forKey: "UpdatedDate") as? String
        userName = aDecoder.decodeObject(forKey: "UserName") as? String
        walletBalance = aDecoder.decodeObject(forKey: "WalletBalance") as? String
        weight = aDecoder.decodeObject(forKey: "Weight") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if accountPrivacy != nil{
            aCoder.encode(accountPrivacy, forKey: "AccountPrivacy")
        }
        if coins != nil{
            aCoder.encode(coins, forKey: "Coins")
        }
        if createdDate != nil{
            aCoder.encode(createdDate, forKey: "CreatedDate")
        }
        if dateOfBirth != nil{
            aCoder.encode(dateOfBirth, forKey: "DateOfBirth")
        }
        if deviceToken != nil{
            aCoder.encode(deviceToken, forKey: "DeviceToken")
        }
        if deviceType != nil{
            aCoder.encode(deviceType, forKey: "DeviceType")
        }
        if email != nil{
            aCoder.encode(email, forKey: "Email")
        }
        if friends != nil{
            aCoder.encode(friends, forKey: "Friends")
        }
        if fullName != nil{
            aCoder.encode(fullName, forKey: "FullName")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "Gender")
        }
        if height != nil{
            aCoder.encode(height, forKey: "Height")
        }
        if iD != nil{
            aCoder.encode(iD, forKey: "ID")
        }
        if inviteFriends != nil{
            aCoder.encode(inviteFriends, forKey: "Invite_friends")
        }
        if latitude != nil{
            aCoder.encode(latitude, forKey: "Latitude")
        }
        if longitude != nil{
            aCoder.encode(longitude, forKey: "Longitude")
        }
        if membership != nil{
            aCoder.encode(membership, forKey: "Membership")
        }
        if memberType != nil{
            aCoder.encode(memberType, forKey: "MemberType")
        }
        if nickName != nil{
            aCoder.encode(nickName, forKey: "NickName")
        }
        if notification != nil{
            aCoder.encode(notification, forKey: "Notification")
        }
        if password != nil{
            aCoder.encode(password, forKey: "Password")
        }
        if phone != nil{
            aCoder.encode(phone, forKey: "Phone")
        }
        if profilePicture != nil{
            aCoder.encode(profilePicture, forKey: "ProfilePicture")
        }
        if referBy != nil{
            aCoder.encode(referBy, forKey: "ReferBy")
        }
        if referralCode != nil{
            aCoder.encode(referralCode, forKey: "ReferralCode")
        }
        if rememberToken != nil{
            aCoder.encode(rememberToken, forKey: "RememberToken")
        }
        if socialID != nil{
            aCoder.encode(socialID, forKey: "SocialID")
        }
        if socialType != nil{
            aCoder.encode(socialType, forKey: "SocialType")
        }
        if status != nil{
            aCoder.encode(status, forKey: "Status")
        }
        if steps != nil{
            aCoder.encode(steps, forKey: "Steps")
        }
        if trash != nil{
            aCoder.encode(trash, forKey: "Trash")
        }
        if updatedDate != nil{
            aCoder.encode(updatedDate, forKey: "UpdatedDate")
        }
        if userName != nil{
            aCoder.encode(userName, forKey: "UserName")
        }
        if walletBalance != nil{
            aCoder.encode(walletBalance, forKey: "WalletBalance")
        }
        if weight != nil{
            aCoder.encode(weight, forKey: "Weight")
        }
    }
}
