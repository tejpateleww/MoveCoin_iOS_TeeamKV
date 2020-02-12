//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 6, 2019

import Foundation
import SwiftyJSON


class WalletData : Codable {

    var coins : String!
    var createdDate : String!
    var descriptionField : String!
    var iD : String!
    var orderID : String!
    var type : String!
    var userID : String!
    var message : String!
    
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
        descriptionField = json["Description"].stringValue
        iD = json["ID"].stringValue
        orderID = json["OrderID"].stringValue
        type = json["Type"].stringValue
        userID = json["UserID"].stringValue
//        let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
        message = json["message"].stringValue
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
        if descriptionField != nil{
        	dictionary["Description"] = descriptionField
        }
        if iD != nil{
        	dictionary["ID"] = iD
        }
        if orderID != nil{
        	dictionary["OrderID"] = orderID
        }
        if type != nil{
        	dictionary["Type"] = type
        }
        if userID != nil{
        	dictionary["UserID"] = userID
        }
        if message != nil{
            dictionary["message"] = message
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
		descriptionField = aDecoder.decodeObject(forKey: "Description") as? String
		iD = aDecoder.decodeObject(forKey: "ID") as? String
		orderID = aDecoder.decodeObject(forKey: "OrderID") as? String
		type = aDecoder.decodeObject(forKey: "Type") as? String
		userID = aDecoder.decodeObject(forKey: "UserID") as? String
        message = aDecoder.decodeObject(forKey: "message") as? String
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
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "Description")
		}
		if iD != nil{
			aCoder.encode(iD, forKey: "ID")
		}
		if orderID != nil{
			aCoder.encode(orderID, forKey: "OrderID")
		}
		if type != nil{
			aCoder.encode(type, forKey: "Type")
		}
		if userID != nil{
			aCoder.encode(userID, forKey: "UserID")
		}
        if message != nil{
            aCoder.encode(userID, forKey: "message")
        }
	}
}
