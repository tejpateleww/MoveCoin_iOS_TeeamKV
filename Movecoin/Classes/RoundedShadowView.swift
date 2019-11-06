//
//  RoundedShadowView.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import UIKit

class RoundedShadowView : UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundedShadowView()
    }
    
    private func roundedShadowView() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowRadius = self.frame.height / 2
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.lightGray.cgColor

        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layoutIfNeeded()
    }
}

class CustomView: UIView {
    
    private var shadowLayer: CAShapeLayer!
    @IBInspectable public var isRounded : Bool = true
    @IBInspectable public var CornerRadiuss: CGFloat = 12.0
    @IBInspectable public var BackColor : UIColor = .white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: isRounded ? (self.frame.size.height/2) : CornerRadiuss).cgPath
            shadowLayer.fillColor = BackColor.cgColor
            shadowLayer.shadowColor = UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 1).cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
            shadowLayer.shadowOpacity = 0.15
            shadowLayer.shadowRadius = 2
            layer.insertSublayer(shadowLayer, at: 0)
            
//            layer.insertSublayer(shadowLayer, below: nil) // also works
        }
//        self.backgroundColor = .white
    }
}
