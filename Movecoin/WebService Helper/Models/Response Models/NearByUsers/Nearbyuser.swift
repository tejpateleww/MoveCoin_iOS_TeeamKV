//
//  Nearbyuser.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 26, 2019

import Foundation
import SwiftyJSON


class Nearbyuser : Codable {

    var distance : String!
    var fullName : String!
    var latitude : String!
    var longitude : String!
    var profilePicture : String!
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
        distance = json["distance"].stringValue
        fullName = json["FullName"].stringValue
        latitude = json["Latitude"].stringValue
        longitude = json["Longitude"].stringValue
        profilePicture = json["ProfilePicture"].stringValue
        userID = json["UserID"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if distance != nil{
            dictionary["distance"] = distance
        }
        if fullName != nil{
            dictionary["FullName"] = fullName
        }
        if latitude != nil{
            dictionary["Latitude"] = latitude
        }
        if longitude != nil{
            dictionary["Longitude"] = longitude
        }
        if profilePicture != nil{
            dictionary["ProfilePicture"] = profilePicture
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
        distance = aDecoder.decodeObject(forKey: "distance") as? String
        fullName = aDecoder.decodeObject(forKey: "FullName") as? String
        latitude = aDecoder.decodeObject(forKey: "Latitude") as? String
        longitude = aDecoder.decodeObject(forKey: "Longitude") as? String
        profilePicture = aDecoder.decodeObject(forKey: "ProfilePicture") as? String
        userID = aDecoder.decodeObject(forKey: "UserID") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if distance != nil{
            aCoder.encode(distance, forKey: "distance")
        }
        if fullName != nil{
            aCoder.encode(fullName, forKey: "FullName")
        }
        if latitude != nil{
            aCoder.encode(latitude, forKey: "Latitude")
        }
        if longitude != nil{
            aCoder.encode(longitude, forKey: "Longitude")
        }
        if profilePicture != nil{
            aCoder.encode(profilePicture, forKey: "ProfilePicture")
        }
        if userID != nil{
            aCoder.encode(userID, forKey: "UserID")
        }

    }

}
