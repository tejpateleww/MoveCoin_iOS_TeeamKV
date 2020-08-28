//
//  Request.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 9, 2019

import Foundation
import SwiftyJSON


class Request : Codable, Comparable {

    var blockByID : String!
    var date : String!
    var friendID : String!
    var fullName : String!
    var iD : String!
    var phone : String!
    var receiverID : String!
    var senderID : String!
    var status : String!
    var userName : String!
    var nickName : String!
    var type : String!
    
    init(){
        
    }
    
    static func < (lhs: Request, rhs: Request) -> Bool {
        return lhs.fullName.capitalizingFirstLetter() < rhs.fullName.capitalizingFirstLetter()
    }
    
    static func == (lhs: Request, rhs: Request) -> Bool {
         return lhs.fullName == rhs.fullName
    }

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        blockByID = json["BlockByID"].stringValue
        date = json["Date"].stringValue
        friendID = json["FriendID"].stringValue
        fullName = json["FullName"].stringValue
        iD = json["ID"].stringValue
        phone = json["Phone"].stringValue
        receiverID = json["ReceiverID"].stringValue
        senderID = json["SenderID"].stringValue
        status = json["Status"].stringValue
        userName = json["UserName"].stringValue
        nickName = json["NickName"].stringValue
        type = json["type"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if blockByID != nil{
        	dictionary["BlockByID"] = blockByID
        }
        if date != nil{
        	dictionary["Date"] = date
        }
        if friendID != nil{
        	dictionary["FriendID"] = friendID
        }
        if fullName != nil{
        	dictionary["FullName"] = fullName
        }
        if iD != nil{
        	dictionary["ID"] = iD
        }
        if phone != nil{
        	dictionary["Phone"] = phone
        }
        if receiverID != nil{
        	dictionary["ReceiverID"] = receiverID
        }
        if senderID != nil{
        	dictionary["SenderID"] = senderID
        }
        if status != nil{
        	dictionary["Status"] = status
        }
        if userName != nil{
        	dictionary["UserName"] = userName
        }
        if nickName != nil{
            dictionary["NickName"] = nickName
        }
        if type != nil{
            dictionary["type"] = type
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		blockByID = aDecoder.decodeObject(forKey: "BlockByID") as? String
		date = aDecoder.decodeObject(forKey: "Date") as? String
		friendID = aDecoder.decodeObject(forKey: "FriendID") as? String
		fullName = aDecoder.decodeObject(forKey: "FullName") as? String
		iD = aDecoder.decodeObject(forKey: "ID") as? String
		phone = aDecoder.decodeObject(forKey: "Phone") as? String
		receiverID = aDecoder.decodeObject(forKey: "ReceiverID") as? String
		senderID = aDecoder.decodeObject(forKey: "SenderID") as? String
		status = aDecoder.decodeObject(forKey: "Status") as? String
		userName = aDecoder.decodeObject(forKey: "UserName") as? String
        nickName = aDecoder.decodeObject(forKey: "NickName") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if blockByID != nil{
			aCoder.encode(blockByID, forKey: "BlockByID")
		}
		if date != nil{
			aCoder.encode(date, forKey: "Date")
		}
		if friendID != nil{
			aCoder.encode(friendID, forKey: "FriendID")
		}
		if fullName != nil{
			aCoder.encode(fullName, forKey: "FullName")
		}
		if iD != nil{
			aCoder.encode(iD, forKey: "ID")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "Phone")
		}
		if receiverID != nil{
			aCoder.encode(receiverID, forKey: "ReceiverID")
		}
		if senderID != nil{
			aCoder.encode(senderID, forKey: "SenderID")
		}
		if status != nil{
			aCoder.encode(status, forKey: "Status")
		}
		if userName != nil{
			aCoder.encode(userName, forKey: "UserName")
		}
        if nickName != nil{
            aCoder.encode(nickName, forKey: "NickName")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
	}
}
