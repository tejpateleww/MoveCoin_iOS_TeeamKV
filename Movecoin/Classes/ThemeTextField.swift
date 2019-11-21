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
}

class TextFieldFont : UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = FontBook.Regular.of(size: 17)
    }
}

