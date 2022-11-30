//
//  CategoryData.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 14, 2021

import Foundation
import SwiftyJSON


class CategoryData : NSObject, NSCoding{

    var categoriesData : [CategoriesDatum]!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        categoriesData = [CategoriesDatum]()
        let categoriesDataArray = json["categories_data"].arrayValue
        for categoriesDataJson in categoriesDataArray{
            let value = CategoriesDatum(fromJson: categoriesDataJson)
            categoriesData.append(value)
        }
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if categoriesData != nil{
        var dictionaryElements = [[String:Any]]()
        for categoriesDataElement in categoriesData {
        	dictionaryElements.append(categoriesDataElement.toDictionary())
        }
        dictionary["categoriesData"] = dictionaryElements
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
		categoriesData = aDecoder.decodeObject(forKey: "categories_data") as? [CategoriesDatum]
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if categoriesData != nil{
			aCoder.encode(categoriesData, forKey: "categories_data")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
