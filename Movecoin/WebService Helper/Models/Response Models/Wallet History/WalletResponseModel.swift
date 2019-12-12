//
//  WalletResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 6, 2019

import Foundation
import SwiftyJSON


class WalletResponseModel : Codable {

    var walletData : [WalletData]!
    var status : Bool!
    var coins : String!
    
    init(){
        
    }

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        walletData = [WalletData]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = WalletData(fromJson: dataJson)
            walletData.append(value)
        }
        status = json["status"].boolValue
        coins = json["coins"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if walletData != nil{
        var dictionaryElements = [[String:Any]]()
        for dataElement in walletData {
        	dictionaryElements.append(dataElement.toDictionary())
        }
        dictionary["data"] = dictionaryElements
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if coins != nil{
            dictionary["coins"] = coins
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		walletData = aDecoder.decodeObject(forKey: "data") as? [WalletData]
		status = aDecoder.decodeObject(forKey: "status") as? Bool
        coins = aDecoder.decodeObject(forKey: "coins") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if walletData != nil{
			aCoder.encode(walletData, forKey: "data")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
        if coins != nil{
            aCoder.encode(coins, forKey: "coins")
        }
	}
}
