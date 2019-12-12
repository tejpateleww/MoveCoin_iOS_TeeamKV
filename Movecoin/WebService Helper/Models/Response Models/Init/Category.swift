//
//  Category.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 3, 2019

import Foundation
import SwiftyJSON


class Category : NSObject, NSCoding{

    var categoryName : String!
    var createdDate : String!
    var iD : String!
    var updatedDate : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        categoryName = json["CategoryName"].stringValue
        createdDate = json["CreatedDate"].stringValue
        iD = json["ID"].stringValue
        updatedDate = json["UpdatedDate"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if categoryName != nil{
        	dictionary["CategoryName"] = categoryName
        }
        if createdDate != nil{
        	dictionary["CreatedDate"] = createdDate
        }
        if iD != nil{
        	dictionary["ID"] = iD
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
		categoryName = aDecoder.decodeObject(forKey: "CategoryName") as? String
		createdDate = aDecoder.decodeObject(forKey: "CreatedDate") as? String
		iD = aDecoder.decodeObject(forKey: "ID") as? String
		updatedDate = aDecoder.decodeObject(forKey: "UpdatedDate") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if categoryName != nil{
			aCoder.encode(categoryName, forKey: "CategoryName")
		}
		if createdDate != nil{
			aCoder.encode(createdDate, forKey: "CreatedDate")
		}
		if iD != nil{
			aCoder.encode(iD, forKey: "ID")
		}
		if updatedDate != nil{
			aCoder.encode(updatedDate, forKey: "UpdatedDate")
		}

	}

}
