//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 25, 2019

import Foundation
import SwiftyJSON


class ProductDetails : Codable{
    
    var avgRatings : String!
    var catID : String!
    var coins : String!
    var createdDate : String!
    var deletedDate : String!
    var deliveryCharge : String!
    var deliveryChargePurchaseLimit : String!
    var descriptionField : String!
    var discount : String!
    var discountedPrice : String!
    var gallaries : [String]!
    var gallery : String!
    var iD : String!
    var isAdminApproved : String!
    var name : String!
    var price : String!
    var priceType : String!
    var productImage : String!
    var qty : String!
    var sellerID : String!
    var status : String!
    var store : String!
    var totalPrice : String!
    var trash : String!
    var isVat : String!
    var vat : String!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        avgRatings = json["AvgRatings"].stringValue
        catID = json["Cat_ID"].stringValue
        coins = json["Coins"].stringValue
        createdDate = json["CreatedDate"].stringValue
        deletedDate = json["DeletedDate"].stringValue
        deliveryCharge = json["delivery_charge"].stringValue
        deliveryChargePurchaseLimit = json["delivery_charge_purchase_limit"].stringValue
        descriptionField = json["Description"].stringValue
        discount = json["Discount"].stringValue
        discountedPrice = json["discounted_price"].stringValue
        gallaries = [String]()
        let gallariesArray = json["gallaries"].arrayValue
        for gallariesJson in gallariesArray{
            gallaries.append(gallariesJson.stringValue)
        }
        gallery = json["Gallery"].stringValue
        iD = json["ID"].stringValue
        isAdminApproved = json["is_admin_approved"].stringValue
        name = json["Name"].stringValue
        price = json["Price"].stringValue
        priceType = json["PriceType"].stringValue
        productImage = json["ProductImage"].stringValue
        qty = json["Qty"].stringValue
        sellerID = json["SellerID"].stringValue
        status = json["Status"].stringValue
        store = json["Store"].stringValue
        totalPrice = json["TotalPrice"].stringValue
        trash = json["Trash"].stringValue
        isVat = json["IsVat"].stringValue
        vat = json["vat"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if avgRatings != nil{
            dictionary["AvgRatings"] = avgRatings
        }
        if catID != nil{
            dictionary["Cat_ID"] = catID
        }
        if coins != nil{
            dictionary["Coins"] = coins
        }
        if createdDate != nil{
            dictionary["CreatedDate"] = createdDate
        }
        if deletedDate != nil{
            dictionary["DeletedDate"] = deletedDate
        }
        if deliveryCharge != nil{
            dictionary["delivery_charge"] = deliveryCharge
        }
        if deliveryChargePurchaseLimit != nil{
            dictionary["delivery_charge_purchase_limit"] = deliveryChargePurchaseLimit
        }
        if descriptionField != nil{
            dictionary["Description"] = descriptionField
        }
        if discount != nil{
            dictionary["Discount"] = discount
        }
        if discountedPrice != nil{
            dictionary["discounted_price"] = discountedPrice
        }
        if gallaries != nil{
            dictionary["gallaries"] = gallaries
        }
        if gallery != nil{
            dictionary["Gallery"] = gallery
        }
        if iD != nil{
            dictionary["ID"] = iD
        }
        if isAdminApproved != nil{
            dictionary["is_admin_approved"] = isAdminApproved
        }
        if name != nil{
            dictionary["Name"] = name
        }
        if price != nil{
            dictionary["Price"] = price
        }
        if priceType != nil{
            dictionary["PriceType"] = priceType
        }
        if productImage != nil{
            dictionary["ProductImage"] = productImage
        }
        if qty != nil{
            dictionary["Qty"] = qty
        }
        if sellerID != nil{
            dictionary["SellerID"] = sellerID
        }
        if status != nil{
            dictionary["Status"] = status
        }
        if store != nil{
            dictionary["Store"] = store
        }
        if totalPrice != nil{
            dictionary["TotalPrice"] = totalPrice
        }
        if trash != nil{
            dictionary["Trash"] = trash
        }
        if isVat != nil{
            dictionary["IsVat"] = isVat
        }
        if vat != nil{
            dictionary["vat"] = vat
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        avgRatings = aDecoder.decodeObject(forKey: "AvgRatings") as? String
        catID = aDecoder.decodeObject(forKey: "Cat_ID") as? String
        coins = aDecoder.decodeObject(forKey: "Coins") as? String
        createdDate = aDecoder.decodeObject(forKey: "CreatedDate") as? String
        deletedDate = aDecoder.decodeObject(forKey: "DeletedDate") as? String
        deliveryCharge = aDecoder.decodeObject(forKey: "delivery_charge") as? String
        deliveryChargePurchaseLimit = aDecoder.decodeObject(forKey: "delivery_charge_purchase_limit") as? String
        descriptionField = aDecoder.decodeObject(forKey: "Description") as? String
        discount = aDecoder.decodeObject(forKey: "Discount") as? String
        discountedPrice = aDecoder.decodeObject(forKey: "discounted_price") as? String
        gallaries = aDecoder.decodeObject(forKey: "gallaries") as? [String]
        gallery = aDecoder.decodeObject(forKey: "Gallery") as? String
        iD = aDecoder.decodeObject(forKey: "ID") as? String
        isAdminApproved = aDecoder.decodeObject(forKey: "is_admin_approved") as? String
        name = aDecoder.decodeObject(forKey: "Name") as? String
        price = aDecoder.decodeObject(forKey: "Price") as? String
        priceType = aDecoder.decodeObject(forKey: "PriceType") as? String
        productImage = aDecoder.decodeObject(forKey: "ProductImage") as? String
        qty = aDecoder.decodeObject(forKey: "Qty") as? String
        sellerID = aDecoder.decodeObject(forKey: "SellerID") as? String
        status = aDecoder.decodeObject(forKey: "Status") as? String
        store = aDecoder.decodeObject(forKey: "Store") as? String
        totalPrice = aDecoder.decodeObject(forKey: "TotalPrice") as? String
        trash = aDecoder.decodeObject(forKey: "Trash") as? String
        isVat = aDecoder.decodeObject(forKey: "IsVat") as? String
        vat = aDecoder.decodeObject(forKey: "vat") as? String

    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if avgRatings != nil{
            aCoder.encode(avgRatings, forKey: "AvgRatings")
        }
        if catID != nil{
            aCoder.encode(catID, forKey: "Cat_ID")
        }
        if coins != nil{
            aCoder.encode(coins, forKey: "Coins")
        }
        if createdDate != nil{
            aCoder.encode(createdDate, forKey: "CreatedDate")
        }
        if deletedDate != nil{
            aCoder.encode(deletedDate, forKey: "DeletedDate")
        }
        if deliveryCharge != nil{
            aCoder.encode(deliveryCharge, forKey: "delivery_charge")
        }
        if deliveryChargePurchaseLimit != nil{
            aCoder.encode(deliveryChargePurchaseLimit, forKey: "delivery_charge_purchase_limit")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "Description")
        }
        if discount != nil{
            aCoder.encode(discount, forKey: "Discount")
        }
        if discountedPrice != nil{
            aCoder.encode(discountedPrice, forKey: "discounted_price")
        }
        if gallaries != nil{
            aCoder.encode(gallaries, forKey: "gallaries")
        }
        if gallery != nil{
            aCoder.encode(gallery, forKey: "Gallery")
        }
        if iD != nil{
            aCoder.encode(iD, forKey: "ID")
        }
        if isAdminApproved != nil{
            aCoder.encode(isAdminApproved, forKey: "is_admin_approved")
        }
        if name != nil{
            aCoder.encode(name, forKey: "Name")
        }
        if price != nil{
            aCoder.encode(price, forKey: "Price")
        }
        if priceType != nil{
            aCoder.encode(priceType, forKey: "PriceType")
        }
        if productImage != nil{
            aCoder.encode(productImage, forKey: "ProductImage")
        }
        if qty != nil{
            aCoder.encode(qty, forKey: "Qty")
        }
        if sellerID != nil{
            aCoder.encode(sellerID, forKey: "SellerID")
        }
        if status != nil{
            aCoder.encode(status, forKey: "Status")
        }
        if store != nil{
            aCoder.encode(store, forKey: "Store")
        }
        if totalPrice != nil{
            aCoder.encode(totalPrice, forKey: "TotalPrice")
        }
        if trash != nil{
            aCoder.encode(trash, forKey: "Trash")
        }
        if isVat != nil{
            aCoder.encode(isVat, forKey: "IsVat")
        }
        if vat != nil{
            aCoder.encode(vat, forKey: "vat")
        }
    }
}
