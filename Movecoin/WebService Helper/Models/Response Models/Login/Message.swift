//
//  Message.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 6, 2020

import Foundation
import SwiftyJSON


class Message : Codable {

    var appleId : String!
    var email : String!
    var firstName : String!
    var lastName : String!

    init(){
        
    }
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        appleId = json["apple_id"].stringValue
        email = json["email"].stringValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if appleId != nil{
        	dictionary["apple_id"] = appleId
        }
        if email != nil{
        	dictionary["email"] = email
        }
        if firstName != nil{
        	dictionary["first_name"] = firstName
        }
        if lastName != nil{
        	dictionary["last_name"] = lastName
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		appleId = aDecoder.decodeObject(forKey: "apple_id") as? String
		email = aDecoder.decodeObject(forKey: "email") as? String
		firstName = aDecoder.decodeObject(forKey: "first_name") as? String
		lastName = aDecoder.decodeObject(forKey: "last_name") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if appleId != nil{
			aCoder.encode(appleId, forKey: "apple_id")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "first_name")
		}
		if lastName != nil{
			aCoder.encode(lastName, forKey: "last_name")
		}

	}

}
