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
        UIView.appearance().semanticContentAttribute = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .forceRightToLeft : .forceLeftToRight
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
                        potentialButton.setTitle(titleString.localized, for: .normal)
                    }
                }
                else if let potentialLabel = view as? UILabel
                {
                    if potentialLabel.textAlignment == .left || potentialLabel.textAlignment == .right {
                         potentialLabel.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
                    }
                    if potentialLabel.text != nil {
                        potentialLabel.text = potentialLabel.text!.localized
                    }
                }
                else if let potentialTextField = view as? UITextField
                {
                    potentialTextField.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
                    if potentialTextField.text != nil {
                        potentialTextField.text = potentialTextField.text!.localized
                        if potentialTextField.placeholder != nil {
                            potentialTextField.placeholder = potentialTextField.placeholder!.localized
                        }
                    }
                }
                else if let potentialTextView = view as? UITextView
                {
                    potentialTextView.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
                    if potentialTextView.text != nil {
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
