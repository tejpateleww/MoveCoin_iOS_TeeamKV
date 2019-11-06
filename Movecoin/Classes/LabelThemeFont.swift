//
//  LabelThemeFont.swift
//  Movecoins
//
//  Created by eww090 on 01/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import UIKit

class LabelThemeFont : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = FontBook.Regular.of(size: 17)
    }
    
    @IBInspectable
    var FontSize: UIFont {
        get {
            return self.font
        }
        set {
            self.font = newValue
        }
    }
}
