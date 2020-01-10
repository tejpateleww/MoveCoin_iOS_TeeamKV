//
//  InitResponse.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 3, 2019

import Foundation
import SwiftyJSON


class InitResponse : Codable {

    var category : [Category]!
    var coinsDiscountRelation : CoinsDiscountRelation!
    var shareLink : String!
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
        category = [Category]()
        let categoryArray = json["category"].arrayValue
        for categoryJson in categoryArray{
            let value = Category(fromJson: categoryJson)
            category.append(value)
        }
        let coinsDiscountRelationJson = json["coins_discount_relation"]
        if !coinsDiscountRelationJson.isEmpty{
            coinsDiscountRelation = CoinsDiscountRelation(fromJson: coinsDiscountRelationJson)
        }
        shareLink = json["ShareLink"].stringValue
        status = json["status"].boolValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if category != nil{
        var dictionaryElements = [[String:Any]]()
        for categoryElement in category {
            dictionaryElements.append(categoryElement.toDictionary())
        }
        dictionary["category"] = dictionaryElements
        }
        if coinsDiscountRelation != nil{
            dictionary["coinsDiscountRelation"] = coinsDiscountRelation.toDictionary()
        }
        if shareLink != nil{
            dictionary["ShareLink"] = shareLink
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
        category = aDecoder.decodeObject(forKey: "category") as? [Category]
        coinsDiscountRelation = aDecoder.decodeObject(forKey: "coins_discount_relation") as? CoinsDiscountRelation
        shareLink = aDecoder.decodeObject(forKey: "ShareLink") as? String
        status = aDecoder.decodeObject(forKey: "status") as? Bool
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if category != nil{
            aCoder.encode(category, forKey: "category")
        }
        if coinsDiscountRelation != nil{
            aCoder.encode(coinsDiscountRelation, forKey: "coins_discount_relation")
        }
        if shareLink != nil{
            aCoder.encode(shareLink, forKey: "ShareLink")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }

    }
}
