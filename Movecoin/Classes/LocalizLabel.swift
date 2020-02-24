//
//  LocalizLabel.swift
//  Movecoins
//
//  Created by eww090 on 07/02/20.
//  Copyright © 2020 eww090. All rights reserved.
//

import Foundation
import UIKit

class LocalizLabel : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if self.textAlignment == .right || self.textAlignment == .left {
            self.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        }
        self.text = self.text?.localized
    }
}
