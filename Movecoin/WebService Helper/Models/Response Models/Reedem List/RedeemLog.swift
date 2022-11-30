//
//  RedeemLog.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 9, 2020

import Foundation
import SwiftyJSON


class RedeemLog : NSObject, NSCoding{

    var accountOwner : String!
    var createdAt : String!
    var ibanBank : String!
    var id : String!
    var isPaid : String!
    var nameOfBank : String!
    var paidDate : String!
    var sar : String!
    var userId : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        accountOwner = json["account_owner"].stringValue
        createdAt = json["created_at"].stringValue
        ibanBank = json["iban_bank"].stringValue
        id = json["id"].stringValue
        isPaid = json["is_paid"].stringValue
        nameOfBank = json["name_of_bank"].stringValue
        paidDate = json["paid_date"].stringValue
        sar = json["sar"].stringValue
        userId = json["user_id"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if accountOwner != nil{
        	dictionary["account_owner"] = accountOwner
        }
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if ibanBank != nil{
        	dictionary["iban_bank"] = ibanBank
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if isPaid != nil{
        	dictionary["is_paid"] = isPaid
        }
        if nameOfBank != nil{
        	dictionary["name_of_bank"] = nameOfBank
        }
        if paidDate != nil{
        	dictionary["paid_date"] = paidDate
        }
        if sar != nil{
        	dictionary["sar"] = sar
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
		accountOwner = aDecoder.decodeObject(forKey: "account_owner") as? String
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		ibanBank = aDecoder.decodeObject(forKey: "iban_bank") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		isPaid = aDecoder.decodeObject(forKey: "is_paid") as? String
		nameOfBank = aDecoder.decodeObject(forKey: "name_of_bank") as? String
		paidDate = aDecoder.decodeObject(forKey: "paid_date") as? String
		sar = aDecoder.decodeObject(forKey: "sar") as? String
		userId = aDecoder.decodeObject(forKey: "user_id") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if accountOwner != nil{
			aCoder.encode(accountOwner, forKey: "account_owner")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if ibanBank != nil{
			aCoder.encode(ibanBank, forKey: "iban_bank")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if isPaid != nil{
			aCoder.encode(isPaid, forKey: "is_paid")
		}
		if nameOfBank != nil{
			aCoder.encode(nameOfBank, forKey: "name_of_bank")
		}
		if paidDate != nil{
			aCoder.encode(paidDate, forKey: "paid_date")
		}
		if sar != nil{
			aCoder.encode(sar, forKey: "sar")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}

	}

}
