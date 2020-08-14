//
//  Result.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 12, 2020

import Foundation
import SwiftyJSON


class SearchData : NSObject, NSCoding{

    var email : String!
    var fullName : String!
    var iD : String!
    var nickName : String!
    var phone : String!
    var profilePicture : String!
    var isFriend : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        email = json["Email"].stringValue
        fullName = json["FullName"].stringValue
        iD = json["ID"].stringValue
        nickName = json["NickName"].stringValue
        phone = json["Phone"].stringValue
        profilePicture = json["ProfilePicture"].stringValue
        isFriend = json["is_friend"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if email != nil{
        	dictionary["Email"] = email
        }
        if fullName != nil{
        	dictionary["FullName"] = fullName
        }
        if iD != nil{
        	dictionary["ID"] = iD
        }
        if nickName != nil{
        	dictionary["NickName"] = nickName
        }
        if phone != nil{
        	dictionary["Phone"] = phone
        }
        if profilePicture != nil{
        	dictionary["ProfilePicture"] = profilePicture
        }
        if isFriend != nil{
            dictionary["is_friend"] = isFriend
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		email = aDecoder.decodeObject(forKey: "Email") as? String
		fullName = aDecoder.decodeObject(forKey: "FullName") as? String
		iD = aDecoder.decodeObject(forKey: "ID") as? String
		nickName = aDecoder.decodeObject(forKey: "NickName") as? String
		phone = aDecoder.decodeObject(forKey: "Phone") as? String
		profilePicture = aDecoder.decodeObject(forKey: "ProfilePicture") as? String
        isFriend = aDecoder.decodeObject(forKey: "is_friend") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if email != nil{
			aCoder.encode(email, forKey: "Email")
		}
		if fullName != nil{
			aCoder.encode(fullName, forKey: "FullName")
		}
		if iD != nil{
			aCoder.encode(iD, forKey: "ID")
		}
		if nickName != nil{
			aCoder.encode(nickName, forKey: "NickName")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "Phone")
		}
		if profilePicture != nil{
			aCoder.encode(profilePicture, forKey: "ProfilePicture")
		}
        if isFriend != nil{
            aCoder.encode(isFriend, forKey: "is_friend")
        }
	}
}
