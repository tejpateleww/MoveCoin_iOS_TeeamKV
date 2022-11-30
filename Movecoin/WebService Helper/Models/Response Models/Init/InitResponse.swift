//
//  InitResponse.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 1, 2021

import Foundation
import SwiftyJSON


class InitResponse : NSObject, NSCoding{

    var category : [Category]!
    var challenge : [ChallengeInit]!
    var coinsDiscountRelation : CoinsDiscountRelation!
    var lastUpdateStepAt : String!
    var serverTime : String!
    var shareLink : String!
    var status : Bool!
    var vat : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        category = [Category]()
        let categoryArray = json["category"].arrayValue
        for categoryJson in categoryArray{
            let value = Category(fromJson: categoryJson)
            category.append(value)
        }
        challenge = [ChallengeInit]()
        let challengeArray = json["challenge"].arrayValue
        for challengeJson in challengeArray{
            let value = ChallengeInit(fromJson: challengeJson)
            challenge.append(value)
        }
        let coinsDiscountRelationJson = json["coins_discount_relation"]
        if !coinsDiscountRelationJson.isEmpty{
            coinsDiscountRelation = CoinsDiscountRelation(fromJson: coinsDiscountRelationJson)
        }
        lastUpdateStepAt = json["last_update_step_at"].stringValue
        serverTime = json["server_time"].stringValue
        shareLink = json["ShareLink"].stringValue
        status = json["status"].boolValue
        vat = json["vat"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if category != nil{
        var dictionaryElements = [[String:Any]]()
        for categoryElement in category {
        	dictionaryElements.append(categoryElement.toDictionary())
        }
        dictionary["category"] = dictionaryElements
        }
        if challenge != nil{
        var dictionaryElements = [[String:Any]]()
        for challengeElement in challenge {
        	dictionaryElements.append(challengeElement.toDictionary())
        }
        dictionary["challenge"] = dictionaryElements
        }
        if coinsDiscountRelation != nil{
        	dictionary["coinsDiscountRelation"] = coinsDiscountRelation.toDictionary()
        }
        if lastUpdateStepAt != nil{
        	dictionary["last_update_step_at"] = lastUpdateStepAt
        }
        if serverTime != nil{
        	dictionary["server_time"] = serverTime
        }
        if shareLink != nil{
        	dictionary["ShareLink"] = shareLink
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if vat != nil{
        	dictionary["vat"] = vat
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		category = aDecoder.decodeObject(forKey: "category") as? [Category]
		challenge = aDecoder.decodeObject(forKey: "challenge") as? [ChallengeInit]
		coinsDiscountRelation = aDecoder.decodeObject(forKey: "coins_discount_relation") as? CoinsDiscountRelation
		lastUpdateStepAt = aDecoder.decodeObject(forKey: "last_update_step_at") as? String
		serverTime = aDecoder.decodeObject(forKey: "server_time") as? String
		shareLink = aDecoder.decodeObject(forKey: "ShareLink") as? String
		status = aDecoder.decodeObject(forKey: "status") as? Bool
		vat = aDecoder.decodeObject(forKey: "vat") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if category != nil{
			aCoder.encode(category, forKey: "category")
		}
		if challenge != nil{
			aCoder.encode(challenge, forKey: "challenge")
		}
		if coinsDiscountRelation != nil{
			aCoder.encode(coinsDiscountRelation, forKey: "coins_discount_relation")
		}
		if lastUpdateStepAt != nil{
			aCoder.encode(lastUpdateStepAt, forKey: "last_update_step_at")
		}
		if serverTime != nil{
			aCoder.encode(serverTime, forKey: "server_time")
		}
		if shareLink != nil{
			aCoder.encode(shareLink, forKey: "ShareLink")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if vat != nil{
			aCoder.encode(vat, forKey: "vat")
		}

	}

}
