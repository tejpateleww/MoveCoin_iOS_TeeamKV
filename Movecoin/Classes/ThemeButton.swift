//
//  ThemeButton.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import UIKit

// ----------------------------------------------------
// MARK: - Custom Button Style
// ----------------------------------------------------

enum buttonTheme: Int {
    case whiteTheme         // 0
    case blueTheme          // 1
    case transparentTheme   // 2
    case whiteBorderTheme   // 3
    case blueBorderTheme    // 4
}

// ----------------------------------------------------
// MARK: - Custom Button Class
// ----------------------------------------------------

class ThemeButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.circelButtonStyle()
    }
    
    var theme : buttonTheme = buttonTheme.whiteTheme  {
        willSet(newTotalSteps) {
            switch newTotalSteps {
            case .whiteTheme:
                whiteTheme()       // 0
            case .blueTheme :
                blueTheme()       // 1
            case .transparentTheme:
                transparentTheme()       // 2
            case .whiteBorderTheme :
                whiteBorderTheme()       // 3
            case .blueBorderTheme:
                blueBorderTheme()       // 4
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        whiteTheme()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        whiteTheme()
    }
    
    override open func prepareForInterfaceBuilder() {
        whiteTheme()
    }
    
    private func whiteTheme() {
        self.backgroundColor = .white
        self.setTitleColor(ThemeBlueColor, for: .normal)
        self.circelButtonStyle()
    }
    
    private func blueTheme() {
        self.backgroundColor = ThemeBlueColor
        self.setTitleColor(.white, for: .normal)
        self.circelButtonStyle()
    }
    
    private func transparentTheme() {
        self.backgroundColor = .init(white: 2.0, alpha: 6.0)
        self.setTitleColor(.white, for: .normal)
        self.circelButtonStyle()
    }
    
    private func whiteBorderTheme() {
        self.backgroundColor = .clear
        self.setTitleColor(.white, for: .normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.circelButtonStyle()
    }
    
    private func blueBorderTheme() {
        self.backgroundColor = .clear
        self.setTitleColor(ThemeBlueColor, for: .normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = ThemeBlueColor.cgColor
        self.circelButtonStyle()
    }
    
    // Background Color
    @IBInspectable
    var setTheme: Int {
        get {
            return self.theme.rawValue
        }
        set {
            self.theme = buttonTheme(rawValue: newValue) ?? .whiteTheme
        }
    }
    
    private func circelButtonStyle() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.size.height / 2
//        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
    }
    
    
}
