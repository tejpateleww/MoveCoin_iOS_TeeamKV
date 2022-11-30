//
//  OfferDetails.swift
//  Movecoins
//
//  Created by Rahul Patel on 24/08/21.
//  Copyright © 2021 eww090. All rights reserved.
//

import Foundation
import SwiftyJSON

class OfferDetailsModel : NSObject, NSCoding{

    var offerDetails : Offer!
    var status : Bool!
    var totalNoOfRedeenOfferUser : Int!
    var userDetails : [OfferUserDetail]!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let offerDetailsJson = json["offer_details"]
        if !offerDetailsJson.isEmpty{
            offerDetails = Offer(fromJson: offerDetailsJson)
        }
        status = json["status"].boolValue
        totalNoOfRedeenOfferUser = json["total_no_of_redeen_offer_user"].intValue
        userDetails = [OfferUserDetail]()
        let userDetailsArray = json["user_details"].arrayValue
        for userDetailsJson in userDetailsArray{
            let value = OfferUserDetail(fromJson: userDetailsJson)
            userDetails.append(value)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if offerDetails != nil{
            dictionary["offerDetails"] = offerDetails.toDictionary()
        }
        if status != nil{
            dictionary["status"] = status
        }
        if totalNoOfRedeenOfferUser != nil{
            dictionary["total_no_of_redeen_offer_user"] = totalNoOfRedeenOfferUser
        }
        if userDetails != nil{
        var dictionaryElements = [[String:Any]]()
        for userDetailsElement in userDetails {
            dictionaryElements.append(userDetailsElement.toDictionary())
        }
        dictionary["userDetails"] = dictionaryElements
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        offerDetails = aDecoder.decodeObject(forKey: "offer_details") as? Offer
        status = aDecoder.decodeObject(forKey: "status") as? Bool
        totalNoOfRedeenOfferUser = aDecoder.decodeObject(forKey: "total_no_of_redeen_offer_user") as? Int
        userDetails = aDecoder.decodeObject(forKey: "user_details") as? [OfferUserDetail]
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if offerDetails != nil{
            aCoder.encode(offerDetails, forKey: "offer_details")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if totalNoOfRedeenOfferUser != nil{
            aCoder.encode(totalNoOfRedeenOfferUser, forKey: "total_no_of_redeen_offer_user")
        }
        if userDetails != nil{
            aCoder.encode(userDetails, forKey: "user_details")
        }

    }

}
