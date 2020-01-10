//
//  CoinsDiscountRelation.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 9, 2020

import Foundation
import SwiftyJSON


class CoinsDiscountRelation : Codable {

    var coins : String!
    var percentageDiscount : String!
    
    init(){
        
    }

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        coins = json["coins"].stringValue
        percentageDiscount = json["percentage_discount"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if coins != nil{
        	dictionary["coins"] = coins
        }
        if percentageDiscount != nil{
        	dictionary["percentage_discount"] = percentageDiscount
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		coins = aDecoder.decodeObject(forKey: "coins") as? String
		percentageDiscount = aDecoder.decodeObject(forKey: "percentage_discount") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if coins != nil{
			aCoder.encode(coins, forKey: "coins")
		}
		if percentageDiscount != nil{
			aCoder.encode(percentageDiscount, forKey: "percentage_discount")
		}

	}

}
