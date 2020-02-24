//
//  UtilityClass.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import CoreImage
import NVActivityIndicatorView

// ----------------------------------------------------
//MARK:- --------- Get Class Name Method ---------
// ----------------------------------------------------

extension NSObject {
    static var className : String {
        return String(describing: self)
    }
}


class UtilityClass : NSObject {
    
    // ----------------------------------------------------
    //MARK:- --------- Change DateFormat Methods ---------
    // ----------------------------------------------------
    
    class func changeDateFormateFrom(dateString: String, fromFormat : String , withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        if(fromFormat.trimmingCharacters(in: .whitespacesAndNewlines).count != 0){
            inputFormatter.dateFormat = fromFormat
        }
//        let UTC = dateString.localToUTC(fromFormate:fromFormat, toFormate: fromFormat)
        if let date = inputFormatter.date(from: dateString){
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            outputFormatter.dateFormat = format
            let str = outputFormatter.string(from: date)
            return str.UTCToLocal(fromFormate: format, toFormate: format)

            //Date.localToUTC(date: str, fromFormat: DateFomateKeys.displayDateTime, toFormat: format, strTimeZone: "Asia/Riyadh")
//            return str
        }
        
        return nil
    }
    
    // ----------------------------------------------------
    //MARK:- --------- Alert Methods ---------
    // ----------------------------------------------------
    
    class func showAlert(Message: String) {
        let alertController = UIAlertController(title: "", message: Message.localized, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        AppDelegateShared.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertWithCompletion(title:String?, Message:String, ButtonTitle:String, Completion:@escaping (() -> ())) {
        
        let alertController = UIAlertController(title: title?.localized , message:Message.localized, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: ButtonTitle.localized, style: .default) { (UIAlertAction) in
            Completion()
        }
        alertController.addAction(OKAction)
        AppDelegateShared.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertWithTwoButtonCompletion(title:String, Message:String,ButtonTitle1:String,ButtonTitle2:String, Completion:@escaping ((Int) -> ())) {
        
        let alertController = UIAlertController(title: title.localized , message:Message.localized, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: ButtonTitle1.localized, style: .default) { (UIAlertAction) in
            Completion(0)
        }
        let CancelAction = UIAlertAction(title: ButtonTitle2.localized, style: .default) { (UIAlertAction) in
            Completion(1)
        }
        alertController.addAction(OKAction)
        alertController.addAction(CancelAction)
        AppDelegateShared.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    /// Response may be Any Type
    class func showAlertOfAPIResponse(param: Any) {
        
        if let res = param as? String {
            UtilityClass.showAlert(Message: res)
        }
        else if let resDict = param as? NSDictionary {
            let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? "message" : "arabic_message"
            if let msg = resDict.object(forKey: msg) as? String {
                UtilityClass.showAlert(Message: msg)
            }
            else if let msg = resDict.object(forKey: "msg") as? String {
                UtilityClass.showAlert(Message: msg)
            }
            else if let msg = resDict.object(forKey: msg) as? [String] {
                UtilityClass.showAlert(Message: msg.first ?? "")
            }
        }
        else if let resAry = param as? NSArray {
            
            if let dictIndxZero = resAry.firstObject as? NSDictionary {
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? "message" : "arabic_message"
                if let message = dictIndxZero.object(forKey: msg) as? String {
                    UtilityClass.showAlert(Message: message)
                }
                else if let msg = dictIndxZero.object(forKey: "msg") as? String {
                    UtilityClass.showAlert(Message: msg)
                }
                else if let msg = dictIndxZero.object(forKey: msg) as? [String] {
                    UtilityClass.showAlert(Message: msg.first ?? "")
                }
            }
            else if let msg = resAry as? [String] {
                UtilityClass.showAlert(Message: msg.first ?? "")
            }
        }
    }
    
    // ----------------------------------------------------
    //MARK:- --------- ActivityIndicator Methods ---------
    // ----------------------------------------------------
    
    class func showHUD() {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    class func hideHUD() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    // ----------------------------------------------------
    //MARK:- --------- Location Methods ---------
    // ----------------------------------------------------
    
    class func alertForLocation(currentVC:UIViewController){
        
        let alertController = UIAlertController(title: "Location Services Disabled".localized, message: "Please enable location services for this app".localized, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings".localized, style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success)
                    
                    in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        
        alertController.addAction(OKAction)
        OperationQueue.main.addOperation {
            currentVC.present(alertController, animated: true,
                              completion:nil)
        }
    }
}
