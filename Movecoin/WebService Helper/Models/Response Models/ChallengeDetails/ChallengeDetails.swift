//
//  ChallengeDetails.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 18, 2021

import Foundation
import SwiftyJSON


class ChallengeDetails : NSObject, NSCoding{

    var status : Bool!
    var topFiveParticipant : [ChallengeTopFiveParticipant]!
    var totalParticipant : Int!
    var yourRank : Int!
    var yourSteps : Int!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        status = json["status"].boolValue
        topFiveParticipant = [ChallengeTopFiveParticipant]()
        let topFiveParticipantArray = json["top_five_participant"].arrayValue
        for topFiveParticipantJson in topFiveParticipantArray{
            let value = ChallengeTopFiveParticipant(fromJson: topFiveParticipantJson)
            topFiveParticipant.append(value)
        }
        totalParticipant = json["total_participant"].intValue
        yourRank = json["your_rank"].intValue
        yourSteps = json["your_steps"].intValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if status != nil{
        	dictionary["status"] = status
        }
        if topFiveParticipant != nil{
        var dictionaryElements = [[String:Any]]()
        for topFiveParticipantElement in topFiveParticipant {
        	dictionaryElements.append(topFiveParticipantElement.toDictionary())
        }
        dictionary["topFiveParticipant"] = dictionaryElements
        }
        if totalParticipant != nil{
        	dictionary["total_participant"] = totalParticipant
        }
        if yourRank != nil{
        	dictionary["your_rank"] = yourRank
        }
        if yourSteps != nil{
        	dictionary["your_steps"] = yourSteps
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		status = aDecoder.decodeObject(forKey: "status") as? Bool
		topFiveParticipant = aDecoder.decodeObject(forKey: "top_five_participant") as? [ChallengeTopFiveParticipant]
		totalParticipant = aDecoder.decodeObject(forKey: "total_participant") as? Int
		yourRank = aDecoder.decodeObject(forKey: "your_rank") as? Int
		yourSteps = aDecoder.decodeObject(forKey: "your_steps") as? Int
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if topFiveParticipant != nil{
			aCoder.encode(topFiveParticipant, forKey: "top_five_participant")
		}
		if totalParticipant != nil{
			aCoder.encode(totalParticipant, forKey: "total_participant")
		}
		if yourRank != nil{
			aCoder.encode(yourRank, forKey: "your_rank")
		}
		if yourSteps != nil{
			aCoder.encode(yourSteps, forKey: "your_steps")
		}

	}

}
