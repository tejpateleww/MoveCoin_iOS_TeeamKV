//
//  CardView.swift
//  Prediction
//
//  Created by PCQ224 on 27/01/21.
//  Copyright © 2021 MAC100. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CardView: UIView {
    
    @IBInspectable var cornerradius: CGFloat = 30.0
    @IBInspectable var shadowOffsetWidth: Int = 1
    @IBInspectable var shadowOffsetHeight: Int = 1
    @IBInspectable var shadowcolor: UIColor? = hexStringToUIColor(hex: "")
    @IBInspectable var bordercolor: UIColor? = UIColor.white
    @IBInspectable var shadowOpacity: Float = 1
    @IBInspectable var borderwidth: CGFloat = 1.0


    override func layoutSubviews() {
        layer.cornerRadius = cornerradius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradius)
    
        layer.masksToBounds = false
        layer.shadowColor = shadowcolor?.cgColor
        layer.borderColor = bordercolor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        layer.borderWidth = borderwidth
    }
}


@IBDesignable
class CardLightView: CardView {
    
    override func layoutSubviews() {
        self.layer.shadowOpacity = 0.0
    }
   
}
