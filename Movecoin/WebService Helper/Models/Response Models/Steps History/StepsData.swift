//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 5, 2019

import Foundation
import SwiftyJSON


class StepsData : Codable, Equatable {
    static func == (lhs: StepsData, rhs: StepsData) -> Bool {
        return  lhs.id == rhs.id  // && lhs.createdDate == rhs.createdDate && lhs.steps == rhs.steps 
    }
    

    var createdDate : String!
    var id : String!
    var steps : String!
    var updatedDate : String!
    var userID : String!
    
    init(){
        
    }

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        createdDate = json["CreatedDate"].stringValue
        id = json["Id"].stringValue
        steps = json["Steps"].stringValue
        updatedDate = json["UpdatedDate"].stringValue
        userID = json["UserID"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if createdDate != nil{
        	dictionary["CreatedDate"] = createdDate
        }
        if id != nil{
        	dictionary["Id"] = id
        }
        if steps != nil{
        	dictionary["Steps"] = steps
        }
        if updatedDate != nil{
        	dictionary["UpdatedDate"] = updatedDate
        }
        if userID != nil{
        	dictionary["UserID"] = userID
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		createdDate = aDecoder.decodeObject(forKey: "CreatedDate") as? String
		id = aDecoder.decodeObject(forKey: "Id") as? String
		steps = aDecoder.decodeObject(forKey: "Steps") as? String
		updatedDate = aDecoder.decodeObject(forKey: "UpdatedDate") as? String
		userID = aDecoder.decodeObject(forKey: "UserID") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if createdDate != nil{
			aCoder.encode(createdDate, forKey: "CreatedDate")
		}
		if id != nil{
			aCoder.encode(id, forKey: "Id")
		}
		if steps != nil{
			aCoder.encode(steps, forKey: "Steps")
		}
		if updatedDate != nil{
			aCoder.encode(updatedDate, forKey: "UpdatedDate")
		}
		if userID != nil{
			aCoder.encode(userID, forKey: "UserID")
		}

	}

}
