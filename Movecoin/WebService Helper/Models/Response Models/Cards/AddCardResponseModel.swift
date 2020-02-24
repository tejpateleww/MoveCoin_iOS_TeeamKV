//
//  RootClass.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 11, 2019

import Foundation
import SwiftyJSON


class AddCardResponseModel : Codable {

    var cards : [Card]!
    var message : String!
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
        let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
        message = msg
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
        if message != nil{
        	dictionary["message"] = message
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
		message = aDecoder.decodeObject(forKey: "message") as? String
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
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
