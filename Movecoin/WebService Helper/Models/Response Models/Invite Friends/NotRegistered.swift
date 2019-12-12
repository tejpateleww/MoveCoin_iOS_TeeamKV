//
//  NotRegistered.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 28, 2019

import Foundation
import SwiftyJSON


class NotRegistered : Codable {

    var phone : String!
    
    init(){
        
    }

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        phone = json["Phone"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if phone != nil{
        	dictionary["Phone"] = phone
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		phone = aDecoder.decodeObject(forKey: "Phone") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if phone != nil{
			aCoder.encode(phone, forKey: "Phone")
		}

	}

}
