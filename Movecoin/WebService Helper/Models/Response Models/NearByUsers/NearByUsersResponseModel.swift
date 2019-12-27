//
//  NearByUsersResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 26, 2019

import Foundation
import SwiftyJSON


class NearByUsersResponseModel : Codable {

    var nearbyuser : [Nearbyuser]!
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
        nearbyuser = [Nearbyuser]()
        let nearbyuserArray = json["nearbyuser"].arrayValue
        for nearbyuserJson in nearbyuserArray{
            let value = Nearbyuser(fromJson: nearbyuserJson)
            nearbyuser.append(value)
        }
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if nearbyuser != nil{
        var dictionaryElements = [[String:Any]]()
        for nearbyuserElement in nearbyuser {
        	dictionaryElements.append(nearbyuserElement.toDictionary())
        }
        dictionary["nearbyuser"] = dictionaryElements
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
		nearbyuser = aDecoder.decodeObject(forKey: "nearbyuser") as? [Nearbyuser]
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if nearbyuser != nil{
			aCoder.encode(nearbyuser, forKey: "nearbyuser")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
