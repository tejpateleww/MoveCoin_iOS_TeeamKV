//
//  Challenge.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 12, 2021

import Foundation
import SwiftyJSON


class Challenge : NSObject, NSCoding{

    var challengeStatus : String!
    var createdAt : String!
    var descriptionField : String!
    var endTime : String!
    var id : String!
    var name : String!
    var noOfParticipants : String!
    var prize : String!
    var prizeImage : String!
    var remainingTime : String!
    var sponserName : String!
    var startTime : String!
    var status : String!
    var trash : String!
    var winnerId : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        challengeStatus = json["challenge_status"].stringValue
        createdAt = json["created_at"].stringValue
        descriptionField = json["description"].stringValue
        endTime = json["end_time"].stringValue
        id = json["id"].stringValue
        name = json["name"].stringValue
        noOfParticipants = json["no_of_participants"].stringValue
        prize = json["prize"].stringValue
        prizeImage = json["prize_image"].stringValue
        remainingTime = json["remaining_time"].stringValue
        sponserName = json["sponser_name"].stringValue
        startTime = json["start_time"].stringValue
        status = json["status"].stringValue
        trash = json["trash"].stringValue
        winnerId = json["winner_id"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if challengeStatus != nil{
        	dictionary["challenge_status"] = challengeStatus
        }
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if descriptionField != nil{
        	dictionary["description"] = descriptionField
        }
        if endTime != nil{
        	dictionary["end_time"] = endTime
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if name != nil{
        	dictionary["name"] = name
        }
        if noOfParticipants != nil{
        	dictionary["no_of_participants"] = noOfParticipants
        }
        if prize != nil{
        	dictionary["prize"] = prize
        }
        if prizeImage != nil{
        	dictionary["prize_image"] = prizeImage
        }
        if remainingTime != nil{
        	dictionary["remaining_time"] = remainingTime
        }
        if sponserName != nil{
        	dictionary["sponser_name"] = sponserName
        }
        if startTime != nil{
        	dictionary["start_time"] = startTime
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if trash != nil{
        	dictionary["trash"] = trash
        }
        if winnerId != nil{
        	dictionary["winner_id"] = winnerId
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		challengeStatus = aDecoder.decodeObject(forKey: "challenge_status") as? String
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		endTime = aDecoder.decodeObject(forKey: "end_time") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		noOfParticipants = aDecoder.decodeObject(forKey: "no_of_participants") as? String
		prize = aDecoder.decodeObject(forKey: "prize") as? String
		prizeImage = aDecoder.decodeObject(forKey: "prize_image") as? String
		remainingTime = aDecoder.decodeObject(forKey: "remaining_time") as? String
		sponserName = aDecoder.decodeObject(forKey: "sponser_name") as? String
		startTime = aDecoder.decodeObject(forKey: "start_time") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		trash = aDecoder.decodeObject(forKey: "trash") as? String
		winnerId = aDecoder.decodeObject(forKey: "winner_id") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if challengeStatus != nil{
			aCoder.encode(challengeStatus, forKey: "challenge_status")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if endTime != nil{
			aCoder.encode(endTime, forKey: "end_time")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if noOfParticipants != nil{
			aCoder.encode(noOfParticipants, forKey: "no_of_participants")
		}
		if prize != nil{
			aCoder.encode(prize, forKey: "prize")
		}
		if prizeImage != nil{
			aCoder.encode(prizeImage, forKey: "prize_image")
		}
		if remainingTime != nil{
			aCoder.encode(remainingTime, forKey: "remaining_time")
		}
		if sponserName != nil{
			aCoder.encode(sponserName, forKey: "sponser_name")
		}
		if startTime != nil{
			aCoder.encode(startTime, forKey: "start_time")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if trash != nil{
			aCoder.encode(trash, forKey: "trash")
		}
		if winnerId != nil{
			aCoder.encode(winnerId, forKey: "winner_id")
		}

	}

}
