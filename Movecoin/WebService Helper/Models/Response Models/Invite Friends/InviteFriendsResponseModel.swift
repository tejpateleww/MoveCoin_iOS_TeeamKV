//
//  InviteFriendsResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 28, 2019

import Foundation
import SwiftyJSON


class InviteFriendsResponseModel : Codable {

    var notRegistered : [NotRegistered]!
    var registered : [Registered]!
    var requests : [Request]!
    var status : Bool!
    var friendRequest : Int!
    
    init(){
        
    }

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        notRegistered = [NotRegistered]()
        let notRegisteredArray = json["NotRegistered"].arrayValue
        for notRegisteredJson in notRegisteredArray{
            let value = NotRegistered(fromJson: notRegisteredJson)
            notRegistered.append(value)
        }
        registered = [Registered]()
        let registeredArray = json["Registered"].arrayValue
        for registeredJson in registeredArray{
            let value = Registered(fromJson: registeredJson)
            registered.append(value)
        }
        requests = [Request]()
        let requestsArray = json["Requests"].arrayValue
        for requestsJson in requestsArray{
            let value = Request(fromJson: requestsJson)
            requests.append(value)
        }
        status = json["status"].boolValue
        friendRequest = json["friend_request"].intValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if notRegistered != nil{
        var dictionaryElements = [[String:Any]]()
        for notRegisteredElement in notRegistered {
        	dictionaryElements.append(notRegisteredElement.toDictionary())
        }
        dictionary["notRegistered"] = dictionaryElements
        }
        if registered != nil{
        var dictionaryElements = [[String:Any]]()
        for registeredElement in registered {
        	dictionaryElements.append(registeredElement.toDictionary())
        }
        dictionary["registered"] = dictionaryElements
        }
        if requests != nil{
        var dictionaryElements = [[String:Any]]()
        for requestsElement in requests {
            dictionaryElements.append(requestsElement.toDictionary())
        }
        dictionary["requests"] = dictionaryElements
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if friendRequest != nil{
            dictionary["friend_request"] = friendRequest
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		notRegistered = aDecoder.decodeObject(forKey: "NotRegistered") as? [NotRegistered]
		registered = aDecoder.decodeObject(forKey: "Registered") as? [Registered]
        requests = aDecoder.decodeObject(forKey: "Requests") as? [Request]
		status = aDecoder.decodeObject(forKey: "status") as? Bool
        friendRequest = aDecoder.decodeObject(forKey: "friend_request") as? Int
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if notRegistered != nil{
			aCoder.encode(notRegistered, forKey: "NotRegistered")
		}
		if registered != nil{
			aCoder.encode(registered, forKey: "Registered")
		}
        if requests != nil{
            aCoder.encode(requests, forKey: "Requests")
        }
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
        if friendRequest != nil{
            aCoder.encode(friendRequest, forKey: "friend_request")
        }
	}

}
