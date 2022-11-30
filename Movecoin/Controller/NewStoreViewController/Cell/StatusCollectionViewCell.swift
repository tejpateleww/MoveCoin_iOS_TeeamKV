//
//  StatusCollectionViewCell.swift
//  Movecoins
//
//  Created by Imac on 14/07/21.
//  Copyright © 2021 eww090. All rights reserved.
//

import UIKit

class StatusCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var vWcell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.vWcell.layer.masksToBounds = true
        self.vWcell.layer.maskedCorners = [.layerMinXMinYCorner , .layerMinXMaxYCorner , .layerMaxXMaxYCorner , .layerMaxXMinYCorner]
        self.vWcell.layer.cornerRadius = 10.0
    }
    
    func toggleSelected ()
      {
          if (isSelected){
            self.vWcell.backgroundColor = UIColor.red
          }else {
            self.vWcell.backgroundColor = ThemeBlueColor
          }
      }
}
