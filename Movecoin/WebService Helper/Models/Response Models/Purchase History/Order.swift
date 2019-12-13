//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 13, 2019

import Foundation
import SwiftyJSON


class Order : Codable {

    var coins : String!
    var discount : String!
    var orderDate : String!
    var productImage : String!
    var productName : String!
    var productId : String!

    init(){
        
    }
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        coins = json["Coins"].stringValue
        discount = json["Discount"].stringValue
        orderDate = json["OrderDate"].stringValue
        productImage = json["ProductImage"].stringValue
        productName = json["ProductName"].stringValue
        productId = json["product_id"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if coins != nil{
        	dictionary["Coins"] = coins
        }
        if discount != nil{
        	dictionary["Discount"] = discount
        }
        if orderDate != nil{
        	dictionary["OrderDate"] = orderDate
        }
        if productImage != nil{
        	dictionary["ProductImage"] = productImage
        }
        if productName != nil{
        	dictionary["ProductName"] = productName
        }
        if productId != nil{
            dictionary["product_id"] = productId
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		coins = aDecoder.decodeObject(forKey: "Coins") as? String
		discount = aDecoder.decodeObject(forKey: "Discount") as? String
		orderDate = aDecoder.decodeObject(forKey: "OrderDate") as? String
		productImage = aDecoder.decodeObject(forKey: "ProductImage") as? String
		productName = aDecoder.decodeObject(forKey: "ProductName") as? String
        productId = aDecoder.decodeObject(forKey: "product_id") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if coins != nil{
			aCoder.encode(coins, forKey: "Coins")
		}
		if discount != nil{
			aCoder.encode(discount, forKey: "Discount")
		}
		if orderDate != nil{
			aCoder.encode(orderDate, forKey: "OrderDate")
		}
		if productImage != nil{
			aCoder.encode(productImage, forKey: "ProductImage")
		}
		if productName != nil{
			aCoder.encode(productName, forKey: "ProductName")
		}
        if productId != nil{
            aCoder.encode(productId, forKey: "product_id")
        }
	}

}
