//
//  FriendsResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 6, 2019

import Foundation
import SwiftyJSON


class FriendsResponseModel : Codable {

    var friendList : [FriendsData]!
    var message : String!
    var status : Bool!
    
    init(){
        
    }

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        friendList = [FriendsData]()
        let friendListArray = json["friend_list"].arrayValue
        for friendListJson in friendListArray{
            let value = FriendsData(fromJson: friendListJson)
            friendList.append(value)
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
        if friendList != nil{
        var dictionaryElements = [[String:Any]]()
        for friendListElement in friendList {
        	dictionaryElements.append(friendListElement.toDictionary())
        }
        dictionary["friendList"] = dictionaryElements
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
		friendList = aDecoder.decodeObject(forKey: "friend_list") as? [FriendsData]
		message = aDecoder.decodeObject(forKey: "message") as? String
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if friendList != nil{
			aCoder.encode(friendList, forKey: "friend_list")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
