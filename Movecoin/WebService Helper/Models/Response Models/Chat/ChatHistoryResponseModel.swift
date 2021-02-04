//
//  ChatHistoryResponseModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 19, 2019

import Foundation
import SwiftyJSON


class ChatHistoryResponseModel : Codable {
    
    var chatHistory : [MessageData]!
    var message : String!
    var status : Bool!
    var receiverArr : ReceiverArr!
    var isFriend : Int!
    
    init() {
        
    }
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        chatHistory = [MessageData]()
        let chatHistoryArray = json["chat_history"].arrayValue
        for chatHistoryJson in chatHistoryArray{
            let value = MessageData(fromJson: chatHistoryJson)
            chatHistory.append(value)
        }
        let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
        message = msg
        status = json["status"].boolValue
        let receiverArrJson = json["receiver_arr"]
        if !receiverArrJson.isEmpty{
            receiverArr = ReceiverArr(fromJson: receiverArrJson)
        }
        isFriend = json["is_friend"].intValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if chatHistory != nil{
            var dictionaryElements = [[String:Any]]()
            for chatHistoryElement in chatHistory {
                dictionaryElements.append(chatHistoryElement.toDictionary())
            }
            dictionary["chatHistory"] = dictionaryElements
        }
        if message != nil{
            dictionary["message"] = message
        }
        if status != nil{
            dictionary["status"] = status
        }
        if receiverArr != nil{
            dictionary["receiverArr"] = receiverArr.toDictionary()
        }
        if isFriend != nil{
            dictionary["is_friend"] = isFriend
        }
    
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        chatHistory = aDecoder.decodeObject(forKey: "chat_history") as? [MessageData]
        message = aDecoder.decodeObject(forKey: "message") as? String
        status = aDecoder.decodeObject(forKey: "status") as? Bool
        receiverArr = aDecoder.decodeObject(forKey: "receiver_arr") as? ReceiverArr
        isFriend = aDecoder.decodeObject(forKey: "is_friend") as? Int
       
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if chatHistory != nil{
            aCoder.encode(chatHistory, forKey: "chat_history")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if receiverArr != nil{
            aCoder.encode(receiverArr, forKey: "receiver_arr")
        }
        if isFriend != nil{
            aCoder.encode(isFriend, forKey: "is_friend")
        }
      
    }
    
}
