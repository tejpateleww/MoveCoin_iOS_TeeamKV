//
//  UIButton + Extension.swift
//  Movecoin
//
//  Created by eww090 on 16/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation

extension UIButton {
    
    func bounceAnimationOnCompletion(completion : @escaping onCompletion){
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(5.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                            self.transform = CGAffineTransform.identity
                        },
                       completion: { Void in
                            self.isUserInteractionEnabled = true
                            completion()
                        })
    }
    
    func attributedString() -> NSAttributedString? {
        let attributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : FontBook.Regular.of(size: 20),
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: self.currentTitle!, attributes: attributes)
        return attributedString
    }
    
//    @IBInspectable
//    var FontName : UIFont {
//        get { return self.titleLabel?.font ?? UIFont() }
//        set {
//            self.titleLabel?.font = newValue
//        }
//    }
}
