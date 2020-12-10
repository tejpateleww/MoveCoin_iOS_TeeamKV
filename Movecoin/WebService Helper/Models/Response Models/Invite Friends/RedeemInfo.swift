//
//  RedeemInfo.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 9, 2020

import Foundation
import SwiftyJSON


class RedeemInfo : NSObject, NSCoding{

    var arabicMessage : String!
    var inviteeCount : String!
    var message : String!
    var status : Bool!
    var totalSar : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        arabicMessage = json["arabic_message"].stringValue
        inviteeCount = json["invitee_count"].stringValue
        message = json["message"].stringValue
        status = json["status"].boolValue
        totalSar = json["total_sar"].stringValue
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
        if inviteeCount != nil{
        	dictionary["invitee_count"] = inviteeCount
        }
        if message != nil{
        	dictionary["message"] = message
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if totalSar != nil{
        	dictionary["total_sar"] = totalSar
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
		inviteeCount = aDecoder.decodeObject(forKey: "invitee_count") as? String
		message = aDecoder.decodeObject(forKey: "message") as? String
		status = aDecoder.decodeObject(forKey: "status") as? Bool
		totalSar = aDecoder.decodeObject(forKey: "total_sar") as? String
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
		if inviteeCount != nil{
			aCoder.encode(inviteeCount, forKey: "invitee_count")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if totalSar != nil{
			aCoder.encode(totalSar, forKey: "total_sar")
		}

	}

}
