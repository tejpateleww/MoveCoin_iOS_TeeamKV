//
//  ChatListResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 18, 2019

import Foundation
import SwiftyJSON


class ChatListResponseModel : Codable {

    var chatList : [ChatList]!
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
        chatList = [ChatList]()
        let chatListArray = json["chat_list"].arrayValue
        for chatListJson in chatListArray{
            let value = ChatList(fromJson: chatListJson)
            chatList.append(value)
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
        if chatList != nil{
        var dictionaryElements = [[String:Any]]()
        for chatListElement in chatList {
        	dictionaryElements.append(chatListElement.toDictionary())
        }
        dictionary["chatList"] = dictionaryElements
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
		chatList = aDecoder.decodeObject(forKey: "chat_list") as? [ChatList]
		message = aDecoder.decodeObject(forKey: "message") as? String
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if chatList != nil{
			aCoder.encode(chatList, forKey: "chat_list")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
