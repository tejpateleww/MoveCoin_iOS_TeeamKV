//
//  RootClass.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 5, 2019

import Foundation
import SwiftyJSON


class StepsHistoryResponseModel : Codable{
    
    var stepsDataList : [StepsData]!
    var status : Bool!
    var totalStepsCount : String!
    
    init(){
        
    }

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
    
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        stepsDataList = [StepsData]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = StepsData(fromJson: dataJson)
            stepsDataList.append(value)
        }
        status = json["status"].boolValue
        totalStepsCount = json["total_steps_count"].stringValue
	}
    
    

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if stepsDataList != nil{
        var dictionaryElements = [[String:Any]]()
        for dataElement in stepsDataList {
        	dictionaryElements.append(dataElement.toDictionary())
        }
        dictionary["data"] = dictionaryElements
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if totalStepsCount != nil{
            dictionary["total_steps_count"] = totalStepsCount
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		stepsDataList = aDecoder.decodeObject(forKey: "data") as? [StepsData]
		status = aDecoder.decodeObject(forKey: "status") as? Bool
        totalStepsCount = aDecoder.decodeObject(forKey: "total_steps_count") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if stepsDataList != nil{
			aCoder.encode(stepsDataList, forKey: "data")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
        if totalStepsCount != nil{
            aCoder.encode(totalStepsCount, forKey: "total_steps_count")
        }

	}

}
