//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 18, 2019

import Foundation
import SwiftyJSON


class MessageData : Codable {

    var chatId : String!
    var date : String!
    var message : String!
    var receiverID : String!
    var senderName : String!
    var senderNickname : String!
    var senderID : String!

    init(){
        
    }
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        chatId = json["chat_id"].stringValue
        date = json["Date"].stringValue
        message = json["Message"].stringValue
        receiverID = json["ReceiverID"].stringValue
        senderName = json["sender_name"].stringValue
        senderNickname = json["sender_nickname"].stringValue
        senderID = json["SenderID"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if chatId != nil{
        	dictionary["chat_id"] = chatId
        }
        if date != nil{
        	dictionary["Date"] = date
        }
        if message != nil{
        	dictionary["Message"] = message
        }
        if receiverID != nil{
        	dictionary["ReceiverID"] = receiverID
        }
        if senderName != nil{
        	dictionary["sender_name"] = senderName
        }
        if senderNickname != nil{
        	dictionary["sender_nickname"] = senderNickname
        }
        if senderID != nil{
        	dictionary["SenderID"] = senderID
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		chatId = aDecoder.decodeObject(forKey: "chat_id") as? String
		date = aDecoder.decodeObject(forKey: "Date") as? String
		message = aDecoder.decodeObject(forKey: "Message") as? String
		receiverID = aDecoder.decodeObject(forKey: "ReceiverID") as? String
		senderName = aDecoder.decodeObject(forKey: "sender_name") as? String
		senderNickname = aDecoder.decodeObject(forKey: "sender_nickname") as? String
		senderID = aDecoder.decodeObject(forKey: "SenderID") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if chatId != nil{
			aCoder.encode(chatId, forKey: "chat_id")
		}
		if date != nil{
			aCoder.encode(date, forKey: "Date")
		}
		if message != nil{
			aCoder.encode(message, forKey: "Message")
		}
		if receiverID != nil{
			aCoder.encode(receiverID, forKey: "ReceiverID")
		}
		if senderName != nil{
			aCoder.encode(senderName, forKey: "sender_name")
		}
		if senderNickname != nil{
			aCoder.encode(senderNickname, forKey: "sender_nickname")
		}
		if senderID != nil{
			aCoder.encode(senderID, forKey: "SenderID")
		}
	}
    
}
