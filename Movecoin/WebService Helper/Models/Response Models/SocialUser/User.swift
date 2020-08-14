//
//  User.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 14, 2020

import Foundation
import SwiftyJSON


class User : NSObject, NSCoding{

    var fullname : String!
    var id : String!
    var isFriend : String!
    var nickname : String!

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

	}

}
