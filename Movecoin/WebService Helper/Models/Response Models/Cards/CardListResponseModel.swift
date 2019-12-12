//
//  CardListResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 11, 2019

import Foundation
import SwiftyJSON


class CardListResponseModel : Codable {

    var cards : [Card]!
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
        cards = [Card]()
        let cardsArray = json["cards"].arrayValue
        for cardsJson in cardsArray{
            let value = Card(fromJson: cardsJson)
            cards.append(value)
        }
        status = json["status"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if cards != nil{
        var dictionaryElements = [[String:Any]]()
        for cardsElement in cards {
        	dictionaryElements.append(cardsElement.toDictionary())
        }
        dictionary["cards"] = dictionaryElements
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
		cards = aDecoder.decodeObject(forKey: "cards") as? [Card]
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if cards != nil{
			aCoder.encode(cards, forKey: "cards")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
