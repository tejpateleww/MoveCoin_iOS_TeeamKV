//
//  List.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 7, 2020

import Foundation
import SwiftyJSON


class List : NSObject, NSCoding{

    var blockBy : String!
    var blockUserId : String!
    var createdAt : String!
    var fullName : String!
    var id : String!
    var nickName : String!
    var profilePicture : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        blockBy = json["block_by"].stringValue
        blockUserId = json["block_user_id"].stringValue
        createdAt = json["created_at"].stringValue
        fullName = json["FullName"].stringValue
        id = json["id"].stringValue
        nickName = json["NickName"].stringValue
        profilePicture = json["ProfilePicture"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if blockBy != nil{
        	dictionary["block_by"] = blockBy
        }
        if blockUserId != nil{
        	dictionary["block_user_id"] = blockUserId
        }
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if fullName != nil{
        	dictionary["FullName"] = fullName
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if nickName != nil{
        	dictionary["NickName"] = nickName
        }
        if profilePicture != nil{
        	dictionary["ProfilePicture"] = profilePicture
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		blockBy = aDecoder.decodeObject(forKey: "block_by") as? String
		blockUserId = aDecoder.decodeObject(forKey: "block_user_id") as? String
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		fullName = aDecoder.decodeObject(forKey: "FullName") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		nickName = aDecoder.decodeObject(forKey: "NickName") as? String
		profilePicture = aDecoder.decodeObject(forKey: "ProfilePicture") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if blockBy != nil{
			aCoder.encode(blockBy, forKey: "block_by")
		}
		if blockUserId != nil{
			aCoder.encode(blockUserId, forKey: "block_user_id")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if fullName != nil{
			aCoder.encode(fullName, forKey: "FullName")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if nickName != nil{
			aCoder.encode(nickName, forKey: "NickName")
		}
		if profilePicture != nil{
			aCoder.encode(profilePicture, forKey: "ProfilePicture")
		}

	}

}
