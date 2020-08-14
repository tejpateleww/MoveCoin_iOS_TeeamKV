//
//  SocialUserResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 14, 2020

import Foundation
import SwiftyJSON


class SocialUserResponseModel : NSObject, NSCoding{

    var message : String!
    var status : Bool!
    var users : [User]!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        message = json["message"].stringValue
        status = json["status"].boolValue
        users = [User]()
        let usersArray = json["users"].arrayValue
        for usersJson in usersArray{
            let value = User(fromJson: usersJson)
            users.append(value)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if message != nil{
        	dictionary["message"] = message
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if users != nil{
        var dictionaryElements = [[String:Any]]()
        for usersElement in users {
        	dictionaryElements.append(usersElement.toDictionary())
        }
        dictionary["users"] = dictionaryElements
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		message = aDecoder.decodeObject(forKey: "message") as? String
		status = aDecoder.decodeObject(forKey: "status") as? Bool
		users = aDecoder.decodeObject(forKey: "users") as? [User]
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if users != nil{
			aCoder.encode(users, forKey: "users")
		}

	}

}
