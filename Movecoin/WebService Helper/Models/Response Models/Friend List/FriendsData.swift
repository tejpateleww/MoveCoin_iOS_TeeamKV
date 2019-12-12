//
//  FriendList.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 6, 2019

import Foundation
import SwiftyJSON


class FriendsData : Codable {

    var fullName : String!
    var iD : String!
    var nickName : String!
    var profilePicture : String!
    var userName : String!
    
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
        iD = json["ID"].stringValue
        nickName = json["NickName"].stringValue
        profilePicture = json["ProfilePicture"].stringValue
        userName = json["UserName"].stringValue
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
        if iD != nil{
        	dictionary["ID"] = iD
        }
        if nickName != nil{
        	dictionary["NickName"] = nickName
        }
        if profilePicture != nil{
        	dictionary["ProfilePicture"] = profilePicture
        }
        if userName != nil{
        	dictionary["UserName"] = userName
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
		iD = aDecoder.decodeObject(forKey: "ID") as? String
		nickName = aDecoder.decodeObject(forKey: "NickName") as? String
		profilePicture = aDecoder.decodeObject(forKey: "ProfilePicture") as? String
		userName = aDecoder.decodeObject(forKey: "UserName") as? String
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
		if iD != nil{
			aCoder.encode(iD, forKey: "ID")
		}
		if nickName != nil{
			aCoder.encode(nickName, forKey: "NickName")
		}
		if profilePicture != nil{
			aCoder.encode(profilePicture, forKey: "ProfilePicture")
		}
		if userName != nil{
			aCoder.encode(userName, forKey: "UserName")
		}

	}

}
