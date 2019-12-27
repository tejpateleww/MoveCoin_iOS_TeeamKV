//
//  UserDetail.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 27, 2019

import Foundation
import SwiftyJSON


class UserDetail : Codable {
    
    var iD : String!
    var fullName : String!
    var isFriend : Int!
    var lastSeen : String!
    var memberSince : String!
    var profilePicture : String!
    var steps : String!
    var updatedDate : String!
    
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
        isFriend = json["is_friend"].intValue
        lastSeen = json["last_seen"].stringValue
        memberSince = json["member_since"].stringValue
        profilePicture = json["ProfilePicture"].stringValue
        steps = json["Steps"].stringValue
        updatedDate = json["UpdatedDate"].stringValue
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
        if isFriend != nil{
            dictionary["is_friend"] = isFriend
        }
        if lastSeen != nil{
            dictionary["last_seen"] = lastSeen
        }
        if memberSince != nil{
            dictionary["member_since"] = memberSince
        }
        if profilePicture != nil{
            dictionary["ProfilePicture"] = profilePicture
        }
        if steps != nil{
            dictionary["Steps"] = steps
        }
        if updatedDate != nil{
            dictionary["UpdatedDate"] = updatedDate
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
        isFriend = aDecoder.decodeObject(forKey: "is_friend") as? Int
        lastSeen = aDecoder.decodeObject(forKey: "last_seen") as? String
        memberSince = aDecoder.decodeObject(forKey: "member_since") as? String
        profilePicture = aDecoder.decodeObject(forKey: "ProfilePicture") as? String
        steps = aDecoder.decodeObject(forKey: "Steps") as? String
        updatedDate = aDecoder.decodeObject(forKey: "UpdatedDate") as? String
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
        if isFriend != nil{
            aCoder.encode(isFriend, forKey: "is_friend")
        }
        if lastSeen != nil{
            aCoder.encode(lastSeen, forKey: "last_seen")
        }
        if memberSince != nil{
            aCoder.encode(memberSince, forKey: "member_since")
        }
        if profilePicture != nil{
            aCoder.encode(profilePicture, forKey: "ProfilePicture")
        }
        if steps != nil{
            aCoder.encode(steps, forKey: "Steps")
        }
        if updatedDate != nil{
            aCoder.encode(updatedDate, forKey: "UpdatedDate")
        }

    }

}
