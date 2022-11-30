//
//  Category.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 1, 2021

import Foundation
import SwiftyJSON


class Category : NSObject, NSCoding{

    var addedBy : String!
    var categoryName : String!
    var createdDate : String!
    var iD : String!
    var tax : String!
    var updatedDate : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        addedBy = json["added_by"].stringValue
        categoryName = json["CategoryName"].stringValue
        createdDate = json["CreatedDate"].stringValue
        iD = json["ID"].stringValue
        tax = json["tax"].stringValue
        updatedDate = json["UpdatedDate"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if addedBy != nil{
        	dictionary["added_by"] = addedBy
        }
        if categoryName != nil{
        	dictionary["CategoryName"] = categoryName
        }
        if createdDate != nil{
        	dictionary["CreatedDate"] = createdDate
        }
        if iD != nil{
        	dictionary["ID"] = iD
        }
        if tax != nil{
        	dictionary["tax"] = tax
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
		addedBy = aDecoder.decodeObject(forKey: "added_by") as? String
		categoryName = aDecoder.decodeObject(forKey: "CategoryName") as? String
		createdDate = aDecoder.decodeObject(forKey: "CreatedDate") as? String
		iD = aDecoder.decodeObject(forKey: "ID") as? String
		tax = aDecoder.decodeObject(forKey: "tax") as? String
		updatedDate = aDecoder.decodeObject(forKey: "UpdatedDate") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if addedBy != nil{
			aCoder.encode(addedBy, forKey: "added_by")
		}
		if categoryName != nil{
			aCoder.encode(categoryName, forKey: "CategoryName")
		}
		if createdDate != nil{
			aCoder.encode(createdDate, forKey: "CreatedDate")
		}
		if iD != nil{
			aCoder.encode(iD, forKey: "ID")
		}
		if tax != nil{
			aCoder.encode(tax, forKey: "tax")
		}
		if updatedDate != nil{
			aCoder.encode(updatedDate, forKey: "UpdatedDate")
		}

	}

}
