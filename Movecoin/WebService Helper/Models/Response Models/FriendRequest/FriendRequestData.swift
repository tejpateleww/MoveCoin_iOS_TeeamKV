//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 12, 2020

import Foundation
import SwiftyJSON


class FriendRequestData : NSObject, NSCoding{

    var blockByID : String!
    var date : String!
    var iD : String!
    var receiverID : String!
    var senderID : String!
    var status : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        blockByID = json["BlockByID"].stringValue
        date = json["Date"].stringValue
        iD = json["ID"].stringValue
        receiverID = json["ReceiverID"].stringValue
        senderID = json["SenderID"].stringValue
        status = json["Status"].stringValue
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
        if iD != nil{
        	dictionary["ID"] = iD
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
		iD = aDecoder.decodeObject(forKey: "ID") as? String
		receiverID = aDecoder.decodeObject(forKey: "ReceiverID") as? String
		senderID = aDecoder.decodeObject(forKey: "SenderID") as? String
		status = aDecoder.decodeObject(forKey: "Status") as? String
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
		if iD != nil{
			aCoder.encode(iD, forKey: "ID")
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

	}

}
