//
//  String + Extension.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation

extension Date {
    var midnight: Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "Europe/Paris")!
        return cal.startOfDay(for: self)
    }
    var midday: Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "Europe/Paris")!
        return cal.date(byAdding: .hour, value: 12, to: self.midnight)!
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    func encodeUTF8() -> String? {
        
        //If I can create an NSURL out of the string nothing is wrong with it
        if let _ = URL(string: self) {
            
            return self
        }
        
        //Get the last component from the string this will return subSequence
        let optionalLastComponent = self.split { $0 == "/" }.last
        
        
        if let lastComponent = optionalLastComponent {
            
            //Get the string from the sub sequence by mapping the characters to [String] then reduce the array to String
            let lastComponentAsString = lastComponent.map { String($0) }.reduce("", +)
            
            
            //Get the range of the last component
            if let rangeOfLastComponent = self.range(of: lastComponentAsString) {
                //Get the string without its last component
                let stringWithoutLastComponent = self.substring(to: rangeOfLastComponent.lowerBound)
                
                
                //Encode the last component
                if let lastComponentEncoded = lastComponentAsString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) {
                    
                    
                    //Finally append the original string (without its last component) to the encoded part (encoded last component)
                    let encodedString = stringWithoutLastComponent + lastComponentEncoded
                    
                    //Return the string (original string/encoded string)
                    return encodedString
                }
            }
        }
        
        return nil;
    }
}
