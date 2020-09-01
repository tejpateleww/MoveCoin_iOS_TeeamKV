//
//  User.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 14, 2020

import Foundation
import SwiftyJSON


class User : NSObject, NSCoding{

    var fullname : String!
    var id : String!
    var isFriend : String! // 0 - Add Friend, 1 - Requested
    var nickname : String!
    var senderID : String!
    var requestID : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        fullname = json["fullname"].stringValue
        id = json["Id"].stringValue
        isFriend = json["is_friend"].stringValue
        nickname = json["nickname"].stringValue
        senderID = json["SenderID"].stringValue
        requestID = json["requestID"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if fullname != nil{
        	dictionary["fullname"] = fullname
        }
        if id != nil{
        	dictionary["Id"] = id
        }
        if isFriend != nil{
        	dictionary["is_friend"] = isFriend
        }
        if nickname != nil{
        	dictionary["nickname"] = nickname
        }
        if senderID != nil{
            dictionary["SenderID"] = senderID
        }
        if requestID != nil{
            dictionary["requestID"] = requestID
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		fullname = aDecoder.decodeObject(forKey: "fullname") as? String
		id = aDecoder.decodeObject(forKey: "Id") as? String
		isFriend = aDecoder.decodeObject(forKey: "is_friend") as? String
		nickname = aDecoder.decodeObject(forKey: "nickname") as? String
        senderID = aDecoder.decodeObject(forKey: "SenderID") as? String
        requestID = aDecoder.decodeObject(forKey: "requestID") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if fullname != nil{
			aCoder.encode(fullname, forKey: "fullname")
		}
		if id != nil{
			aCoder.encode(id, forKey: "Id")
		}
		if isFriend != nil{
			aCoder.encode(isFriend, forKey: "is_friend")
		}
		if nickname != nil{
			aCoder.encode(nickname, forKey: "nickname")
		}
        if senderID != nil{
            aCoder.encode(senderID, forKey: "SenderID")
        }
        if requestID != nil{
            aCoder.encode(requestID, forKey: "requestID")
        }
	}

}
