//
//  purchaseHIstory.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 15, 2021

import Foundation
import SwiftyJSON


class PurchaseHistoryList : NSObject, NSCoding{

    var history : [History]!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        history = [History]()
        let historyArray = json["history"].arrayValue
        for historyJson in historyArray{
            let value = History(fromJson: historyJson)
            history.append(value)
        }
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if history != nil{
        var dictionaryElements = [[String:Any]]()
        for historyElement in history {
        	dictionaryElements.append(historyElement.toDictionary())
        }
        dictionary["history"] = dictionaryElements
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
		history = aDecoder.decodeObject(forKey: "history") as? [History]
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if history != nil{
			aCoder.encode(history, forKey: "history")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
