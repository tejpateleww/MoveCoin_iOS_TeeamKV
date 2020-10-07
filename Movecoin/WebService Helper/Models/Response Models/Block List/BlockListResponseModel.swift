//
//  BlockListResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 7, 2020

import Foundation
import SwiftyJSON


class BlockListResponseModel : NSObject, NSCoding{

    var arabicMessage : String!
    var list : [List]!
    var message : String!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        arabicMessage = json["arabic_message"].stringValue
        list = [List]()
        let listArray = json["list"].arrayValue
        for listJson in listArray{
            let value = List(fromJson: listJson)
            list.append(value)
        }
        message = json["message"].stringValue
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if arabicMessage != nil{
        	dictionary["arabic_message"] = arabicMessage
        }
        if list != nil{
        var dictionaryElements = [[String:Any]]()
        for listElement in list {
        	dictionaryElements.append(listElement.toDictionary())
        }
        dictionary["list"] = dictionaryElements
        }
        if message != nil{
        	dictionary["message"] = message
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
		arabicMessage = aDecoder.decodeObject(forKey: "arabic_message") as? String
		list = aDecoder.decodeObject(forKey: "list") as? [List]
		message = aDecoder.decodeObject(forKey: "message") as? String
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if arabicMessage != nil{
			aCoder.encode(arabicMessage, forKey: "arabic_message")
		}
		if list != nil{
			aCoder.encode(list, forKey: "list")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
