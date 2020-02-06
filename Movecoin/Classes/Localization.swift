//
//  Localization.swift
//  Movecoins
//
//  Created by eww090 on 04/02/20.
//  Copyright © 2020 eww090. All rights reserved.
//

import Foundation

//let secondLanguage = "ar-AE" // "sw"

/// Internal current language key
let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"

/// Default language. English. If English is unavailable defaults to base localization.
//let LCLDefaultLanguage = "en"

/// Name for language change notification
public let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"



enum Languages : String {
    case English = "en"
    case Arabic = "ar-AE"
}


// MARK: Language Setting Functions

open class Localize: NSObject {
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    open class func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.index(of: "Base"), excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    /**
     Current language
     - Returns: The current language. String.
     */
    open class func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
//            print("currentLanguage: \(currentLanguage)")
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    /**
     Change the current language
     - Parameter language: Desired language.
     */
    open class func setCurrentLanguage(_ language: String) {
        
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
           
        }
         NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    /**
     Default language
     - Returns: The app's default language. String.
     */
    open class func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return Languages.English.rawValue
        }
        let availableLanguages: [String] = self.availableLanguages()
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = Languages.English.rawValue
        }
        return defaultLanguage
    }
    
    /**
     Resets the current language to the default
     */
    open class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    open class func displayNameForLanguage(_ language: String) -> String {
        let locale : Locale = Locale(identifier: currentLanguage())
        if let displayName = (locale as NSLocale).displayName(forKey: NSLocale.Key.languageCode, value: language) {
            return displayName
        }
        return String()
    }
}


func localizeString(stringToLocalize:String) -> String
{
    // Get the corresponding bundle path.
    let selectedLanguage = Localize.currentLanguage()
    let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj")
    
    // Get the corresponding localized string.
    let languageBundle = Bundle(path: path!)
    return languageBundle!.localizedString(forKey: stringToLocalize, value: "", table: nil)
}

func localizeUI(parentView:UIView)
{
    UIView.appearance().semanticContentAttribute = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .forceRightToLeft : .forceLeftToRight
    
    DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
            for view:UIView in parentView.subviews
            {
                if let potentialButton = view as? UIButton
                {
                    if let titleString = potentialButton.titleLabel?.text {
//                        potentialButton.setTitle(localizeString(stringToLocalize: titleString), for: .normal)
                        potentialButton.setTitle(titleString.localized, for: .normal)
                    }
                }
                else if let potentialLabel = view as? UILabel
                {
                    if potentialLabel.textAlignment == .left || potentialLabel.textAlignment == .right {
                         potentialLabel.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
                    }
                    if potentialLabel.text != nil {
//                        potentialLabel.text = localizeString(stringToLocalize: potentialLabel.text!)
                        potentialLabel.text = potentialLabel.text!.localized
                    }
                }
                else if let potentialTextField = view as? UITextField
                {
                    potentialTextField.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
                    if potentialTextField.text != nil {
//                        potentialTextField.text = localizeString(stringToLocalize: potentialTextField.text!)
                        potentialTextField.text = potentialTextField.text!.localized
                        if potentialTextField.placeholder != nil {
//                             potentialTextField.placeholder = localizeString(stringToLocalize: potentialTextField.placeholder!)
                            potentialTextField.placeholder = potentialTextField.placeholder!.localized
                        }
                    }
                }
                else if let potentialTextView = view as? UITextView
                {
                    potentialTextView.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
                    if potentialTextView.text != nil {
//                        potentialTextView.text = localizeString(stringToLocalize: potentialTextView.text!)
                        potentialTextView.text = potentialTextView.text!.localized
                    }
                }
                localizeUI(parentView: view)
            }
        }
    }
}

extension String {
    var localized: String {

        let lang = UserDefaults.standard.string(forKey: LCLCurrentLanguageKey)
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}



//// constants
//let APPLE_LANGUAGE_KEY = "AppleLanguages"
//
///// L102Language
//class L102Language {
//
//    /// get current Apple language
//    class func currentAppleLanguage() -> String{
//        let userdef = UserDefaults.standard
////        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
////        let current = langArray.firstObject as! String
//        if let lang = userdef.string(forKey: "i18n_language") {
//            return lang
//        } else {
//            return "en"
//        }
//    }
//
//    /// set @lang to be the first in Applelanguages list
//    class func setAppleLAnguageTo(lang: String) {
//        let userdef = UserDefaults.standard
//        userdef.set([lang], forKey: APPLE_LANGUAGE_KEY)
//        userdef.synchronize()
//    }
//}
//
//extension UIViewController {
//
//    func loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: [UIView]) {
//        if subviews.count > 0 {
//            for subView in subviews {
//                if subView.isKind(of:UIImageView.self) && subView.tag < 0 {
//                    let toRightArrow = subView as! UIImageView
//                    if let _img = toRightArrow.image {
//                        /*1*/toRightArrow.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImage.Orientation.upMirrored)
//                    }
//                }
//                /*2*/loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: subView.subviews)
//            }
//        }
//    }
//}
//class MirroringViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //        if L102Language.currentAppleLanguage() == "ar" {
//        //            loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: self.view.subviews)
//        //        }
//        if L102Language.currentAppleLanguage() == secondLanguage {
//            DispatchQueue.main.async {
//                UIView.appearance().semanticContentAttribute = .forceRightToLeft
//                UITextField.appearance().semanticContentAttribute = .forceRightToLeft
//            }
//        } else {
//            DispatchQueue.main.async {
//                UIView.appearance().semanticContentAttribute = .forceLeftToRight
//                UITextField.appearance().semanticContentAttribute = .forceLeftToRight
//            }
//        }
//    }
//}
//
//var userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
//    get {
//        var direction = UIUserInterfaceLayoutDirection.leftToRight
//        if L102Language.currentAppleLanguage() == secondLanguage {
//            direction = .rightToLeft
//        }
//        return direction
//    }
//}
