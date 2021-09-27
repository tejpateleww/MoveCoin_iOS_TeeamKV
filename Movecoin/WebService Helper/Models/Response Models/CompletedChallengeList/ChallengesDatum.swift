//
//  ChallengesDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 14, 2021

import Foundation
import SwiftyJSON


class ChallengesDatum : NSObject, NSCoding{

    var descriptionField : String!
    var endTime : String!
    var name : String!
    var nickName : String!
    var prizeImage : String!
    var totalParticipant : Int!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        descriptionField = json["description"].stringValue
        endTime = json["end_time"].stringValue
        name = json["name"].stringValue
        nickName = json["NickName"].stringValue
        prizeImage = json["prize_image"].stringValue
        totalParticipant = json["total_participant"].intValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if descriptionField != nil{
        	dictionary["description"] = descriptionField
        }
        if endTime != nil{
        	dictionary["end_time"] = endTime
        }
        if name != nil{
        	dictionary["name"] = name
        }
        if nickName != nil{
        	dictionary["NickName"] = nickName
        }
        if prizeImage != nil{
        	dictionary["prize_image"] = prizeImage
        }
        if totalParticipant != nil{
        	dictionary["total_participant"] = totalParticipant
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		endTime = aDecoder.decodeObject(forKey: "end_time") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		nickName = aDecoder.decodeObject(forKey: "NickName") as? String
		prizeImage = aDecoder.decodeObject(forKey: "prize_image") as? String
		totalParticipant = aDecoder.decodeObject(forKey: "total_participant") as? Int
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if endTime != nil{
			aCoder.encode(endTime, forKey: "end_time")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if nickName != nil{
			aCoder.encode(nickName, forKey: "NickName")
		}
		if prizeImage != nil{
			aCoder.encode(prizeImage, forKey: "prize_image")
		}
		if totalParticipant != nil{
			aCoder.encode(totalParticipant, forKey: "total_participant")
		}

	}

}
