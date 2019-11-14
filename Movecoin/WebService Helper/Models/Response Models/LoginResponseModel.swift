//
//  LoginResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 13, 2019

import Foundation
import SwiftyJSON


class LoginResponseModel : Codable {

    var data : UserData!
    var message : String!
    var status : Bool!
    var xApiKey : String!
    
    init() {
        
    }

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        let dataJson = json["data"]
        if !dataJson.isEmpty{
            data = UserData(fromJson: dataJson)
        }
        message = json["message"].stringValue
        status = json["status"].boolValue
        xApiKey = json["x-api-key"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if data != nil{
        	dictionary["data"] = data.toDictionary()
        }
        if message != nil{
        	dictionary["message"] = message
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if xApiKey != nil{
        	dictionary["x-api-key"] = xApiKey
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		data = aDecoder.decodeObject(forKey: "data") as? UserData
		message = aDecoder.decodeObject(forKey: "message") as? String
		status = aDecoder.decodeObject(forKey: "status") as? Bool
		xApiKey = aDecoder.decodeObject(forKey: "x-api-key") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if data != nil{
			aCoder.encode(data, forKey: "data")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if xApiKey != nil{
			aCoder.encode(xApiKey, forKey: "x-api-key")
		}

	}

}
