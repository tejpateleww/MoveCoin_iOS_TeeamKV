//
//  MonthStepsCount.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 23, 2019

import Foundation
import SwiftyJSON


class MonthStepsCount : NSObject, NSCoding{

    var datePartition : String!
    var totalSteps : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        datePartition = json["date"].stringValue
        totalSteps = json["total_steps"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if datePartition != nil{
        	dictionary["date"] = datePartition
        }
        if totalSteps != nil{
        	dictionary["total_steps"] = totalSteps
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		datePartition = aDecoder.decodeObject(forKey: "date") as? String
		totalSteps = aDecoder.decodeObject(forKey: "total_steps") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if datePartition != nil{
			aCoder.encode(datePartition, forKey: "date")
		}
		if totalSteps != nil{
			aCoder.encode(totalSteps, forKey: "total_steps")
		}

	}

}
