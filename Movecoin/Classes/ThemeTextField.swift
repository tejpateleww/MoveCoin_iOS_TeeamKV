//
//  ThemeTextField.swift
//  Movecoin
//
//  Created by eww090 on 09/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import FormTextField

class ThemeTextfield : SkyFloatingLabelTextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.textAlignment = (L102Language.currentAppleLanguage() == secondLanguage) ? .right : .left
        self.selectedTitleColor = .white
        self.selectedLineColor = TransparentColor
        self.font = FontBook.Regular.of(size: 20.0)
        self.placeholderColor = .white
        self.tintColor = .white
        self.textColor = .init(white: 1.0, alpha: 0.7)
        self.lineColor = TransparentColor
        self.titleColor = .white
        self.titleFormatter = { $0 }
        self.undoManager?.removeAllActions()
    }
}

class DropDownThemeTextfield : SkyFloatingLabelTextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        self.textAlignment = (L102Language.currentAppleLanguage() == secondLanguage) ? .right : .left
        self.selectedTitleColor = .white
        self.selectedLineColor = TransparentColor
        self.font = FontBook.Regular.of(size: 20.0)
        self.placeholderColor = .white
        self.tintColor = .white
        self.textColor = .init(white: 1.0, alpha: 0.7)
        self.lineColor = TransparentColor
        self.titleColor = .white
        self.titleFormatter = { $0 }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.isMenuVisible = false
        
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

class TextFieldFont : UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = FontBook.Regular.of(size: 17)
        self.undoManager?.removeAllActions()
//        self.textAlignment = (L102Language.currentAppleLanguage() == secondLanguage) ? .right : .left
    }
}

class DropDownTextField : UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = FontBook.Regular.of(size: 17)
//        self.textAlignment = (L102Language.currentAppleLanguage() == secondLanguage) ? .right : .left
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.isMenuVisible = false
        
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

