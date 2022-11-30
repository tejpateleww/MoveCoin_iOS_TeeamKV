//
//  CategoriesDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 14, 2021

import Foundation
import SwiftyJSON


class CategoriesDatum : NSObject, NSCoding{

    var categoryName : String!
    var iD : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        categoryName = json["CategoryName"].stringValue
        iD = json["ID"].stringValue
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
        if iD != nil{
        	dictionary["ID"] = iD
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
		iD = aDecoder.decodeObject(forKey: "ID") as? String
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
		if iD != nil{
			aCoder.encode(iD, forKey: "ID")
		}

	}

}
