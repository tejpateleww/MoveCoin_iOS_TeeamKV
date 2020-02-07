//
//  LocalizButton.swift
//  Movecoins
//
//  Created by eww090 on 07/02/20.
//  Copyright © 2020 eww090. All rights reserved.
//

import Foundation
import UIKit

class LocalizButton : UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if self.titleLabel?.textAlignment == .right || self.titleLabel?.textAlignment == .left {
            self.titleLabel?.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        }
        self.setTitle(self.titleLabel?.text?.localized, for: .normal) 
    }
}
