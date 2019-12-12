//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 6, 2019

import Foundation
import SwiftyJSON


class CoinsEarn : Codable {

    var coins : String!
    var createdDate : String!
    var iD : String!
    var steps : String!
    var userID : String!

    init(){
        
    }
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        coins = json["Coins"].stringValue
        createdDate = json["CreatedDate"].stringValue
        iD = json["ID"].stringValue
        steps = json["Steps"].stringValue
        userID = json["UserID"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if coins != nil{
        	dictionary["Coins"] = coins
        }
        if createdDate != nil{
        	dictionary["CreatedDate"] = createdDate
        }
        if iD != nil{
        	dictionary["ID"] = iD
        }
        if steps != nil{
        	dictionary["Steps"] = steps
        }
        if userID != nil{
        	dictionary["UserID"] = userID
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		coins = aDecoder.decodeObject(forKey: "Coins") as? String
		createdDate = aDecoder.decodeObject(forKey: "CreatedDate") as? String
		iD = aDecoder.decodeObject(forKey: "ID") as? String
		steps = aDecoder.decodeObject(forKey: "Steps") as? String
		userID = aDecoder.decodeObject(forKey: "UserID") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if coins != nil{
			aCoder.encode(coins, forKey: "Coins")
		}
		if createdDate != nil{
			aCoder.encode(createdDate, forKey: "CreatedDate")
		}
		if iD != nil{
			aCoder.encode(iD, forKey: "ID")
		}
		if steps != nil{
			aCoder.encode(steps, forKey: "Steps")
		}
		if userID != nil{
			aCoder.encode(userID, forKey: "UserID")
		}

	}

}
