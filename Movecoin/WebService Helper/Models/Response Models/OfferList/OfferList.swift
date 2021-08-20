//
//  OfferList.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 18, 2021

import Foundation
import SwiftyJSON


class OfferList : NSObject, NSCoding{

    var offers : [Offer]!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        offers = [Offer]()
        let offersArray = json["offers"].arrayValue
        for offersJson in offersArray{
            let value = Offer(fromJson: offersJson)
            offers.append(value)
        }
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if offers != nil{
        var dictionaryElements = [[String:Any]]()
        for offersElement in offers {
        	dictionaryElements.append(offersElement.toDictionary())
        }
        dictionary["offers"] = dictionaryElements
        }
        if status != nil{
        	dictionary["status"] = status
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		offers = aDecoder.decodeObject(forKey: "offers") as? [Offer]
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if offers != nil{
			aCoder.encode(offers, forKey: "offers")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
