//
//  RedeemList.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 9, 2020

import Foundation
import SwiftyJSON


class RedeemList : NSObject, NSCoding{

    var arabicMessage : String!
    var message : String!
    var redeemLog : [RedeemLog]!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        arabicMessage = json["arabic_message"].stringValue
        message = json["message"].stringValue
        redeemLog = [RedeemLog]()
        let redeemLogArray = json["redeem_log"].arrayValue
        for redeemLogJson in redeemLogArray{
            let value = RedeemLog(fromJson: redeemLogJson)
            redeemLog.append(value)
        }
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if arabicMessage != nil{
        	dictionary["arabic_message"] = arabicMessage
        }
        if message != nil{
        	dictionary["message"] = message
        }
        if redeemLog != nil{
        var dictionaryElements = [[String:Any]]()
        for redeemLogElement in redeemLog {
        	dictionaryElements.append(redeemLogElement.toDictionary())
        }
        dictionary["redeemLog"] = dictionaryElements
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
		arabicMessage = aDecoder.decodeObject(forKey: "arabic_message") as? String
		message = aDecoder.decodeObject(forKey: "message") as? String
		redeemLog = aDecoder.decodeObject(forKey: "redeem_log") as? [RedeemLog]
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if arabicMessage != nil{
			aCoder.encode(arabicMessage, forKey: "arabic_message")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if redeemLog != nil{
			aCoder.encode(redeemLog, forKey: "redeem_log")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
