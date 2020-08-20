//
//  CategoryListResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 18, 2020

import Foundation
import SwiftyJSON


class CategoryListResponseModel : NSObject, NSCoding{

    var category : [Category]!
    var status : Bool!

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
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
