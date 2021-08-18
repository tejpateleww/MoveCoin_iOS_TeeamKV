//
//  NewStoreTableViewCell.swift
//  Movecoins
//
//  Created by Imac on 14/07/21.
//  Copyright © 2021 eww090. All rights reserved.
//

import UIKit

class NewStoreTableViewCell: UITableViewCell {
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblCoins: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblOutOfStock: UILabel!
    @IBOutlet weak var viewOutOfStock: UIView!
    @IBOutlet weak var vwCell: UIView!
    
    var product: Offer? {
        didSet{
            if let data = product {
                self.lblProductName.text = data.name
                self.lblCoins.text = data.coins
                self.lblProductName.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
                // For Image
                let productsURL = NetworkEnvironment.baseImageURL + data.image
                if let url = URL(string: productsURL) {
                    self.imgProduct.kf.indicatorType = .activity
                    self.imgProduct.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))

                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        lblCoins.font = UIFont.regular(ofSize: 15)
        lblProductName.font = UIFont.regular(ofSize: 16)
        lblOutOfStock.font = UIFont.regular(ofSize: 28)
        self.vwCell.layer.masksToBounds = true
        self.vwCell.layer.maskedCorners = [.layerMinXMinYCorner , .layerMinXMaxYCorner , .layerMaxXMaxYCorner , .layerMaxXMinYCorner]
        self.vwCell.layer.cornerRadius = 30.0
        
        self.vwCell.layer.borderColor = UIColor.lightGray.cgColor
        self.vwCell.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
