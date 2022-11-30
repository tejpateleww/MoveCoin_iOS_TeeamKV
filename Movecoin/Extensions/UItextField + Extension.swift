//
//  UItextField + Extension.swift
//  Movecoin
//
//  Created by eww090 on 30/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation

extension UITextField {
    
    func placeholderColour(Colour : UIColor , PlaceHolder : String){
        let placeholderColor: UIColor = Colour
        let attributes = [ NSAttributedString.Key.foregroundColor: placeholderColor]
        attributedPlaceholder = NSAttributedString(string: PlaceHolder, attributes: attributes)
    }
    
    @IBInspectable
    var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = ValidatorClass.validatorFor(type: validationType)
        return try validator.validated(self.text!.trimmingCharacters(in: .whitespacesAndNewlines), (self.placeholder?.lowercased())!)
    }
}

