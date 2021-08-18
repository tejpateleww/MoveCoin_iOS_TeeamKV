//
//  UIFont + Extension.swift
//  Movecoins
//
//  Created by eww090 on 01/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation


//struct AppFontName {
//    static let regular = "Cairo-Regular"
//    static let bold = "Cairo-Bold"
//    static let light = "Cairo-Light"
//}

extension UIFont {
    class func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name:  FontBook.Regular.rawValue, size: size)!
    }
    class func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontBook.Regular.rawValue, size: size)!
    }
    class func light(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontBook.Light.rawValue , size: size)!
    }
    class func semiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontBook.Regular.rawValue , size: size)!
    }
    
    /*
     private class func manageFont(font : CGFloat) -> CGFloat {
     let cal  = windowHeight * font
     print(CGFloat(cal / CGFloat(screenHeightDeveloper)))
     return CGFloat(cal / CGFloat(screenHeightDeveloper))
     }
     */
    
}
