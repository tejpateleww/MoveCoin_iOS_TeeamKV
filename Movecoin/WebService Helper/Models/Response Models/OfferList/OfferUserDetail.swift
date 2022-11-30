//
//  UserDetail.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 24, 2021

import Foundation
import SwiftyJSON


class OfferUserDetail : NSObject, NSCoding{

    var fullName : String!
    var nickName : String!
    var userId : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        fullName = json["FullName"].stringValue
        nickName = json["NickName"].stringValue
        userId = json["user_id"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if fullName != nil{
        	dictionary["FullName"] = fullName
        }
        if nickName != nil{
        	dictionary["NickName"] = nickName
        }
        if userId != nil{
        	dictionary["user_id"] = userId
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		fullName = aDecoder.decodeObject(forKey: "FullName") as? String
		nickName = aDecoder.decodeObject(forKey: "NickName") as? String
		userId = aDecoder.decodeObject(forKey: "user_id") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if fullName != nil{
			aCoder.encode(fullName, forKey: "FullName")
		}
		if nickName != nil{
			aCoder.encode(nickName, forKey: "NickName")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}

	}

}
