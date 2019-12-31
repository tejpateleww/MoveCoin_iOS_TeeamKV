//
//  RootClass.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 30, 2019

import Foundation
import SwiftyJSON


class PolicyHelpTermsClass : Codable {

    var helpLink : String!
    var policyLink : String!
    var termsLink : String!
    
    init(){
        
    }

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        helpLink = json["help_link"].stringValue
        policyLink = json["policy_link"].stringValue
        termsLink = json["terms_link"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if helpLink != nil{
        	dictionary["help_link"] = helpLink
        }
        if policyLink != nil{
        	dictionary["policy_link"] = policyLink
        }
        if termsLink != nil{
        	dictionary["terms_link"] = termsLink
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		helpLink = aDecoder.decodeObject(forKey: "help_link") as? String
		policyLink = aDecoder.decodeObject(forKey: "policy_link") as? String
		termsLink = aDecoder.decodeObject(forKey: "terms_link") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if helpLink != nil{
			aCoder.encode(helpLink, forKey: "help_link")
		}
		if policyLink != nil{
			aCoder.encode(policyLink, forKey: "policy_link")
		}
		if termsLink != nil{
			aCoder.encode(termsLink, forKey: "terms_link")
		}

	}

}
