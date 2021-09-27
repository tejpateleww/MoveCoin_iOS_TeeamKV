//
//  Challenge.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 1, 2021

import Foundation
import SwiftyJSON


class ChallengeInit : NSObject, NSCoding{

    var challengeId : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        challengeId = json["challenge_id"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if challengeId != nil{
        	dictionary["challenge_id"] = challengeId
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		challengeId = aDecoder.decodeObject(forKey: "challenge_id") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if challengeId != nil{
			aCoder.encode(challengeId, forKey: "challenge_id")
		}

	}

}
