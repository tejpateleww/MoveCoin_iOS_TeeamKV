//
//  SearchFriendResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 12, 2020

import Foundation
import SwiftyJSON


class SearchFriendResponseModel : NSObject, NSCoding{

    var message : String!
    var result : [SearchData]!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        message = json["message"].stringValue
        result = [SearchData]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = SearchData(fromJson: resultJson)
            result.append(value)
        }
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if message != nil{
        	dictionary["message"] = message
        }
        if result != nil{
        var dictionaryElements = [[String:Any]]()
        for resultElement in result {
        	dictionaryElements.append(resultElement.toDictionary())
        }
        dictionary["result"] = dictionaryElements
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
		message = aDecoder.decodeObject(forKey: "message") as? String
		result = aDecoder.decodeObject(forKey: "result") as? [SearchData]
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if result != nil{
			aCoder.encode(result, forKey: "result")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}


/*
 
 The webservice call is for https://www.movecoins.net/admin/api/friends/search_friend and the params are
  {
   "search_str" : "ryna"
 }
 the response is {
   "status" : true,
   "result" : [
     {
       "NickName" : "Belinda",
       "Phone" : "4747472020",
       "Email" : "ryna@yopmail.com",
       "ProfilePicture" : "assets\/images\/users\/4e4c3a961ee76addb6f67fcf077a6310.jpeg",
       "FullName" : "Ryna",
       "ID" : "145"
     }
   ],
   "message" : ""
 }
 
 */
