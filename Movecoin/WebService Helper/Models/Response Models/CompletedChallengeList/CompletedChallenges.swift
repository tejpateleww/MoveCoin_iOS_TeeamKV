//
//  CompletedChallenges.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 14, 2021

import Foundation
import SwiftyJSON


class CompletedChallenges : NSObject, NSCoding{

    var challengesData : [ChallengesDatum]!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        challengesData = [ChallengesDatum]()
        let challengesDataArray = json["challenges_data"].arrayValue
        for challengesDataJson in challengesDataArray{
            let value = ChallengesDatum(fromJson: challengesDataJson)
            challengesData.append(value)
        }
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if challengesData != nil{
        var dictionaryElements = [[String:Any]]()
        for challengesDataElement in challengesData {
        	dictionaryElements.append(challengesDataElement.toDictionary())
        }
        dictionary["challengesData"] = dictionaryElements
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
		challengesData = aDecoder.decodeObject(forKey: "challenges_data") as? [ChallengesDatum]
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if challengesData != nil{
			aCoder.encode(challengesData, forKey: "challenges_data")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
