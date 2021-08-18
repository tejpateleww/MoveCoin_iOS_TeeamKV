//
//  ChallengeMain.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 12, 2021

import Foundation
import SwiftyJSON


class ChallengeMain : NSObject, NSCoding{

    var challenge : Challenge!
    var status : Bool!
    var time : String!
    var isParticipant : Bool!
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
        status = json["status"].boolValue
        time = json["time"].stringValue
        isParticipant = json["is_participant"].boolValue
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
        if status != nil{
        	dictionary["status"] = status
        }
        if time != nil{
        	dictionary["time"] = time
        }
        if isParticipant != nil{
            dictionary["is_participant"] = isParticipant
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
		status = aDecoder.decodeObject(forKey: "status") as? Bool
		time = aDecoder.decodeObject(forKey: "time") as? String
        isParticipant = aDecoder.decodeObject(forKey: "is_participant") as? Bool
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
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if time != nil{
			aCoder.encode(time, forKey: "time")
		}
        if isParticipant != nil{
            aCoder.encode(isParticipant, forKey: "is_participant")
        }
	}

}
