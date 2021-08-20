//
//  Offer.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 18, 2021

import Foundation
import SwiftyJSON


class Offer : NSObject, NSCoding{

    var categoryId : String!
    var coins : String!
    var couponCode : String!
    var createdAt : String!
    var howToClaim : String!
    var id : String!
    var image : String!
    var link : String!
    var name : String!
    var noOfRedeemUser : String!
    var offerType : String!
    var status : String!
    var termsAndCondition : String!
    var trash : String!
    var updatedAt : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        categoryId = json["category_id"].stringValue
        coins = json["coins"].stringValue
        couponCode = json["coupon_code"].stringValue
        createdAt = json["created_at"].stringValue
        howToClaim = json["how_to_claim"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        link = json["link"].stringValue
        name = json["name"].stringValue
        noOfRedeemUser = json["no_of_redeem_user"].stringValue
        offerType = json["offer_type"].stringValue
        status = json["status"].stringValue
        termsAndCondition = json["terms_and_condition"].stringValue
        trash = json["trash"].stringValue
        updatedAt = json["updated_at"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if categoryId != nil{
        	dictionary["category_id"] = categoryId
        }
        if coins != nil{
        	dictionary["coins"] = coins
        }
        if couponCode != nil{
        	dictionary["coupon_code"] = couponCode
        }
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if howToClaim != nil{
        	dictionary["how_to_claim"] = howToClaim
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if image != nil{
        	dictionary["image"] = image
        }
        if link != nil{
        	dictionary["link"] = link
        }
        if name != nil{
        	dictionary["name"] = name
        }
        if noOfRedeemUser != nil{
        	dictionary["no_of_redeem_user"] = noOfRedeemUser
        }
        if offerType != nil{
        	dictionary["offer_type"] = offerType
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if termsAndCondition != nil{
        	dictionary["terms_and_condition"] = termsAndCondition
        }
        if trash != nil{
        	dictionary["trash"] = trash
        }
        if updatedAt != nil{
        	dictionary["updated_at"] = updatedAt
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		categoryId = aDecoder.decodeObject(forKey: "category_id") as? String
		coins = aDecoder.decodeObject(forKey: "coins") as? String
		couponCode = aDecoder.decodeObject(forKey: "coupon_code") as? String
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		howToClaim = aDecoder.decodeObject(forKey: "how_to_claim") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		link = aDecoder.decodeObject(forKey: "link") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		noOfRedeemUser = aDecoder.decodeObject(forKey: "no_of_redeem_user") as? String
		offerType = aDecoder.decodeObject(forKey: "offer_type") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		termsAndCondition = aDecoder.decodeObject(forKey: "terms_and_condition") as? String
		trash = aDecoder.decodeObject(forKey: "trash") as? String
		updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if categoryId != nil{
			aCoder.encode(categoryId, forKey: "category_id")
		}
		if coins != nil{
			aCoder.encode(coins, forKey: "coins")
		}
		if couponCode != nil{
			aCoder.encode(couponCode, forKey: "coupon_code")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if howToClaim != nil{
			aCoder.encode(howToClaim, forKey: "how_to_claim")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if link != nil{
			aCoder.encode(link, forKey: "link")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if noOfRedeemUser != nil{
			aCoder.encode(noOfRedeemUser, forKey: "no_of_redeem_user")
		}
		if offerType != nil{
			aCoder.encode(offerType, forKey: "offer_type")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if termsAndCondition != nil{
			aCoder.encode(termsAndCondition, forKey: "terms_and_condition")
		}
		if trash != nil{
			aCoder.encode(trash, forKey: "trash")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}

	}

}
