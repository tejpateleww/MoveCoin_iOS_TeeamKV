//
//  ProductDetailCollectionViewCell.swift
//  Movecoin
//
//  Created by eww090 on 10/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class ProductDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgProduct: UIImageView!
    
    var productImage: String? {
        didSet{
            if let data = productImage {
                // For Image
                let productsURL = NetworkEnvironment.baseGalleryURL + data
                if let url = URL(string: productsURL) {
                    self.imgProduct.kf.indicatorType = .activity
                    self.imgProduct.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
