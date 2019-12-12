//
//  Registered.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 28, 2019

import Foundation
import SwiftyJSON


class Registered : Codable, Comparable {

    var fullName : String!
    var iD : String!
    var isFriend : Int!
    var phone : String!
    
    init(){
        
    }
    
    static func < (lhs: Registered, rhs: Registered) -> Bool {
        return lhs.fullName.capitalizingFirstLetter() < rhs.fullName.capitalizingFirstLetter()
    }
    
    static func == (lhs: Registered, rhs: Registered) -> Bool {
         return lhs.fullName == rhs.fullName
    }

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        fullName = json["FullName"].stringValue
        iD = json["ID"].stringValue
        isFriend = json["is_friend"].intValue
        phone = json["Phone"].stringValue
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
        if iD != nil{
        	dictionary["ID"] = iD
        }
        if isFriend != nil{
        	dictionary["is_friend"] = isFriend
        }
        if phone != nil{
        	dictionary["Phone"] = phone
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
		iD = aDecoder.decodeObject(forKey: "ID") as? String
		isFriend = aDecoder.decodeObject(forKey: "is_friend") as? Int
		phone = aDecoder.decodeObject(forKey: "Phone") as? String
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
		if iD != nil{
			aCoder.encode(iD, forKey: "ID")
		}
		if isFriend != nil{
			aCoder.encode(isFriend, forKey: "is_friend")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "Phone")
		}

	}

}
