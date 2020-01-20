//
//  ChatList.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 18, 2019

import Foundation
import SwiftyJSON


class ChatList : Codable {

    var fullName : String!
    var nickName : String!
    var lastMessageDate : String!
    var profilePicture : String!
    var iD : String!

    init(){
        
    }
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        fullName = json["FullName"].stringValue
        nickName = json["NickName"].stringValue
        lastMessageDate = json["last_message_date"].stringValue
        profilePicture = json["ProfilePicture"].stringValue
        iD = json["ID"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if fullName != nil{
        	dictionary["FullName"] = fullName
        }
        if nickName != nil{
            dictionary["NickName"] = nickName
        }
        if lastMessageDate != nil{
        	dictionary["last_message_date"] = lastMessageDate
        }
        if profilePicture != nil{
        	dictionary["ProfilePicture"] = profilePicture
        }
        if iD != nil{
        	dictionary["ID"] = iD
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		fullName = aDecoder.decodeObject(forKey: "FullName") as? String
        nickName = aDecoder.decodeObject(forKey: "NickName") as? String
		lastMessageDate = aDecoder.decodeObject(forKey: "last_message_date") as? String
		profilePicture = aDecoder.decodeObject(forKey: "ProfilePicture") as? String
		iD = aDecoder.decodeObject(forKey: "ID") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if fullName != nil{
			aCoder.encode(fullName, forKey: "FullName")
		}
        if nickName != nil{
            aCoder.encode(nickName, forKey: "NickName")
        }
		if lastMessageDate != nil{
			aCoder.encode(lastMessageDate, forKey: "last_message_date")
		}
		if profilePicture != nil{
			aCoder.encode(profilePicture, forKey: "ProfilePicture")
		}
		if iD != nil{
			aCoder.encode(iD, forKey: "ID")
		}
	}
}
