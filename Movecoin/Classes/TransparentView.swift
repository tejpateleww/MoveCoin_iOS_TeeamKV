//
//  TransparentView.swift
//  Movecoin
//
//  Created by eww090 on 05/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import UIKit


class TransparentView : UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.transparentBackground()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func transparentBackground(){
        self.backgroundColor = .init(white: 1.0, alpha: 0.23)
    }
}
