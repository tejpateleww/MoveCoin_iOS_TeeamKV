//
//  StoreTableViewCell.swift
//  Movecoin
//
//  Created by eww090 on 12/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var view: UIView!
    
    var productDetail: ProductDetail? {
        didSet{
            if let detail = productDetail {
                self.lblDiscount.text = detail.discount + "% Off"
                self.lblProductName.text = detail.name
                self.lblPrice.text = detail.price
                self.imgProduct.image = UIImage(named: detail.image)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        view.transform = CGAffineTransform(rotationAngle: CGFloat(Double(-45) * .pi/180))
        lblPrice.font = UIFont.regular(ofSize: 15)
        lblDiscount.font = UIFont.semiBold(ofSize: 13)
        lblProductName.font = UIFont.semiBold(ofSize: 18)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
