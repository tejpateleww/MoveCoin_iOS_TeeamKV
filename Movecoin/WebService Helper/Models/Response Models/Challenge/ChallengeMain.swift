//
//  ChallengeDetails.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 1, 2021

import Foundation
import SwiftyJSON


class ChallengeMain : NSObject, NSCoding{

    var challenge : Challenge!
    var isParticipant : Int!
    var status : Bool!
    var time : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        let challengeJson = json["challenge"]
        if !challengeJson.isEmpty{
            challenge = Challenge(fromJson: challengeJson)
        }
        isParticipant = json["is_participant"].intValue
        status = json["status"].boolValue
        time = json["time"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if challenge != nil{
        	dictionary["challenge"] = challenge.toDictionary()
        }
        if isParticipant != nil{
        	dictionary["is_participant"] = isParticipant
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if time != nil{
        	dictionary["time"] = time
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		challenge = aDecoder.decodeObject(forKey: "challenge") as? Challenge
		isParticipant = aDecoder.decodeObject(forKey: "is_participant") as? Int
		status = aDecoder.decodeObject(forKey: "status") as? Bool
		time = aDecoder.decodeObject(forKey: "time") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if challenge != nil{
			aCoder.encode(challenge, forKey: "challenge")
		}
		if isParticipant != nil{
			aCoder.encode(isParticipant, forKey: "is_participant")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if time != nil{
			aCoder.encode(time, forKey: "time")
		}

	}

}
