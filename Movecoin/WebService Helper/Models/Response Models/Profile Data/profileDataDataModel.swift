//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 23, 2019

import Foundation
import SwiftyJSON


class profileDataDataModel : NSObject, NSCoding{

    var friends : String!
    var monthStepsCount : [profileDataMonthStepsCount]!
    var todayStepsCount : String!
    var totalCoins : String!
    var totalStepsCount : String!
    var weekStepsCount : [profileDataWeekStepsCount]!
    var avarageMonthStepsCount : String!
    var avarageWeekStepsCount : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        avarageMonthStepsCount = json["avarage_month_steps_count"].stringValue
        avarageWeekStepsCount = json["avarage_week_steps_count"].stringValue
        friends = json["Friends"].stringValue
        monthStepsCount = [profileDataMonthStepsCount]()
        let monthStepsCountArray = json["month_steps_count"].arrayValue
        for monthStepsCountJson in monthStepsCountArray{
            let value = profileDataMonthStepsCount(fromJson: monthStepsCountJson)
            monthStepsCount.append(value)
        }
        todayStepsCount = json["today_steps_count"].stringValue
        totalCoins = json["total_coins"].stringValue
        totalStepsCount = json["total_steps_count"].stringValue
        weekStepsCount = [profileDataWeekStepsCount]()
        let weekStepsCountArray = json["week_steps_count"].arrayValue
        for weekStepsCountJson in weekStepsCountArray{
            let value = profileDataWeekStepsCount(fromJson: weekStepsCountJson)
            weekStepsCount.append(value)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        
        if avarageMonthStepsCount != nil{
            dictionary["avarage_month_steps_count"] = avarageMonthStepsCount
        }
        if avarageWeekStepsCount != nil{
            dictionary["avarage_week_steps_count"] = avarageWeekStepsCount
        }
        if friends != nil{
        	dictionary["Friends"] = friends
        }
        if monthStepsCount != nil{
        var dictionaryElements = [[String:Any]]()
        for monthStepsCountElement in monthStepsCount {
        	dictionaryElements.append(monthStepsCountElement.toDictionary())
        }
        dictionary["monthStepsCount"] = dictionaryElements
        }
        if todayStepsCount != nil{
        	dictionary["today_steps_count"] = todayStepsCount
        }
        if totalCoins != nil{
        	dictionary["total_coins"] = totalCoins
        }
        if totalStepsCount != nil{
        	dictionary["total_steps_count"] = totalStepsCount
        }
        if weekStepsCount != nil{
        var dictionaryElements = [[String:Any]]()
        for weekStepsCountElement in weekStepsCount {
        	dictionaryElements.append(weekStepsCountElement.toDictionary())
        }
        dictionary["weekStepsCount"] = dictionaryElements
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
        avarageMonthStepsCount = aDecoder.decodeObject(forKey: "avarage_month_steps_count") as? String
        avarageWeekStepsCount = aDecoder.decodeObject(forKey: "avarage_week_steps_count") as? String
		friends = aDecoder.decodeObject(forKey: "Friends") as? String
		monthStepsCount = aDecoder.decodeObject(forKey: "month_steps_count") as? [profileDataMonthStepsCount]
		todayStepsCount = aDecoder.decodeObject(forKey: "today_steps_count") as? String
		totalCoins = aDecoder.decodeObject(forKey: "total_coins") as? String
		totalStepsCount = aDecoder.decodeObject(forKey: "total_steps_count") as? String
		weekStepsCount = aDecoder.decodeObject(forKey: "week_steps_count") as? [profileDataWeekStepsCount]
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
        if avarageMonthStepsCount != nil{
            aCoder.encode(avarageMonthStepsCount, forKey: "avarage_month_steps_count")
        }
        if avarageWeekStepsCount != nil{
            aCoder.encode(avarageWeekStepsCount, forKey: "avarage_week_steps_count")
        }
		if friends != nil{
			aCoder.encode(friends, forKey: "Friends")
		}
		if monthStepsCount != nil{
			aCoder.encode(monthStepsCount, forKey: "month_steps_count")
		}
		if todayStepsCount != nil{
			aCoder.encode(todayStepsCount, forKey: "today_steps_count")
		}
		if totalCoins != nil{
			aCoder.encode(totalCoins, forKey: "total_coins")
		}
		if totalStepsCount != nil{
			aCoder.encode(totalStepsCount, forKey: "total_steps_count")
		}
		if weekStepsCount != nil{
			aCoder.encode(weekStepsCount, forKey: "week_steps_count")
		}

	}

}
