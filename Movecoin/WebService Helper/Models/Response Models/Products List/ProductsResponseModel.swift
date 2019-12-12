//
//  ProductsResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2019

import Foundation
import SwiftyJSON


class ProductsResponseModel : Codable{

    var productsList : [ProductDetails]!
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
        productsList = [ProductDetails]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = ProductDetails(fromJson: dataJson)
            productsList.append(value)
        }
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if productsList != nil{
        var dictionaryElements = [[String:Any]]()
        for dataElement in productsList {
        	dictionaryElements.append(dataElement.toDictionary())
        }
        dictionary["data"] = dictionaryElements
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
		productsList = aDecoder.decodeObject(forKey: "data") as? [ProductDetails]
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if productsList != nil{
			aCoder.encode(productsList, forKey: "data")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
	}
}
