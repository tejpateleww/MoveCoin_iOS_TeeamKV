//
//  NearByUserDetailResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 27, 2019

import Foundation
import SwiftyJSON


class NearByUserDetailResponseModel : Codable {

    var status : Bool!
    var userDetail : UserDetail!
    
    init(){
        
    }

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        status = json["status"].boolValue
        let userDetailJson = json["user_detail"]
        if !userDetailJson.isEmpty{
            userDetail = UserDetail(fromJson: userDetailJson)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if status != nil{
        	dictionary["status"] = status
        }
        if userDetail != nil{
        	dictionary["userDetail"] = userDetail.toDictionary()
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		status = aDecoder.decodeObject(forKey: "status") as? Bool
		userDetail = aDecoder.decodeObject(forKey: "user_detail") as? UserDetail
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if userDetail != nil{
			aCoder.encode(userDetail, forKey: "user_detail")
		}

	}

}
