//
//  Localization.swift
//  Movecoins
//
//  Created by eww090 on 04/02/20.
//  Copyright © 2020 eww090. All rights reserved.
//

import Foundation


// constants
let APPLE_LANGUAGE_KEY = "AppleLanguages"

/// L102Language
class L102Language {
    
    /// get current Apple language
    class func currentAppleLanguage() -> String{
        let userdef = UserDefaults.standard
//        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
//        let current = langArray.firstObject as! String
        if let lang = userdef.string(forKey: "i18n_language") {
            return lang
        } else {
            return "en"
        }
    }
    
    /// set @lang to be the first in Applelanguages list
    class func setAppleLAnguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }
}

extension UIViewController {
    
    func loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if subView.isKind(of:UIImageView.self) && subView.tag < 0 {
                    let toRightArrow = subView as! UIImageView
                    if let _img = toRightArrow.image {
                        /*1*/toRightArrow.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImage.Orientation.upMirrored)
                    }
                }
                /*2*/loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: subView.subviews)
            }
        }
    }
}
class MirroringViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if L102Language.currentAppleLanguage() == "ar" {
        //            loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: self.view.subviews)
        //        }
        if L102Language.currentAppleLanguage() == secondLanguage {
            DispatchQueue.main.async {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                UITextField.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            DispatchQueue.main.async {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                UITextField.appearance().semanticContentAttribute = .forceLeftToRight
            }
        }
    }
}

var userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
    get {
        var direction = UIUserInterfaceLayoutDirection.leftToRight
        if L102Language.currentAppleLanguage() == secondLanguage {
            direction = .rightToLeft
        }
        return direction
    }
}
