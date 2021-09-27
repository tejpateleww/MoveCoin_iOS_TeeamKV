//
//  History.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 15, 2021

import Foundation
import SwiftyJSON


class History : NSObject, NSCoding{

    var coins : String!
    var descriptionField : String!
    var descriptionImage : String!
    var howToClaim : String!
    var id : String!
    var image : String!
    var link : String!
    var name : String!
    var offerDetails : String!
    var offerType : String!
    var createdAt : String!
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        coins = json["coins"].stringValue
        descriptionField = json["description"].stringValue
        descriptionImage = json["description_image"].stringValue
        howToClaim = json["how_to_claim"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        link = json["link"].stringValue
        name = json["name"].stringValue
        offerDetails = json["offer_details"].stringValue
        offerType = json["offer_type"].stringValue
        createdAt = json["created_at"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if coins != nil{
        	dictionary["coins"] = coins
        }
        if descriptionField != nil{
        	dictionary["description"] = descriptionField
        }
        if descriptionImage != nil{
        	dictionary["description_image"] = descriptionImage
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
        if offerDetails != nil{
        	dictionary["offer_details"] = offerDetails
        }
        if offerType != nil{
        	dictionary["offer_type"] = offerType
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		coins = aDecoder.decodeObject(forKey: "coins") as? String
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		descriptionImage = aDecoder.decodeObject(forKey: "description_image") as? String
		howToClaim = aDecoder.decodeObject(forKey: "how_to_claim") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		link = aDecoder.decodeObject(forKey: "link") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		offerDetails = aDecoder.decodeObject(forKey: "offer_details") as? String
		offerType = aDecoder.decodeObject(forKey: "offer_type") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if coins != nil{
			aCoder.encode(coins, forKey: "coins")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if descriptionImage != nil{
			aCoder.encode(descriptionImage, forKey: "description_image")
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
		if offerDetails != nil{
			aCoder.encode(offerDetails, forKey: "offer_details")
		}
		if offerType != nil{
			aCoder.encode(offerType, forKey: "offer_type")
		}

	}

}
