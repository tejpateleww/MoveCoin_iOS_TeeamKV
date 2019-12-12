//
//  Card.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 11, 2019

import Foundation
import SwiftyJSON


class Card : Codable {

    var alias : String!
    var cardNum : String!
    var cardNum2 : String!
    var expiry : String!
    var id : String!
    var type : String!
    
    init(){
        
    }

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        alias = json["Alias"].stringValue
        cardNum = json["CardNum"].stringValue
        cardNum2 = json["CardNum2"].stringValue
        expiry = json["Expiry"].stringValue
        id = json["Id"].stringValue
        type = json["Type"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if alias != nil{
        	dictionary["Alias"] = alias
        }
        if cardNum != nil{
        	dictionary["CardNum"] = cardNum
        }
        if cardNum2 != nil{
        	dictionary["CardNum2"] = cardNum2
        }
        if expiry != nil{
        	dictionary["Expiry"] = expiry
        }
        if id != nil{
        	dictionary["Id"] = id
        }
        if type != nil{
        	dictionary["Type"] = type
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		alias = aDecoder.decodeObject(forKey: "Alias") as? String
		cardNum = aDecoder.decodeObject(forKey: "CardNum") as? String
		cardNum2 = aDecoder.decodeObject(forKey: "CardNum2") as? String
		expiry = aDecoder.decodeObject(forKey: "Expiry") as? String
		id = aDecoder.decodeObject(forKey: "Id") as? String
		type = aDecoder.decodeObject(forKey: "Type") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if alias != nil{
			aCoder.encode(alias, forKey: "Alias")
		}
		if cardNum != nil{
			aCoder.encode(cardNum, forKey: "CardNum")
		}
		if cardNum2 != nil{
			aCoder.encode(cardNum2, forKey: "CardNum2")
		}
		if expiry != nil{
			aCoder.encode(expiry, forKey: "Expiry")
		}
		if id != nil{
			aCoder.encode(id, forKey: "Id")
		}
		if type != nil{
			aCoder.encode(type, forKey: "Type")
		}

	}

}
