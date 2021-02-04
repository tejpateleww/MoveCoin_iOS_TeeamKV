//
//  StoreTableViewCell.swift
//  Movecoin
//
//  Created by eww090 on 12/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import Kingfisher

class StoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCoins: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var lblDiscountedPrice: UILabel!
    @IBOutlet weak var lblPriceDiscount: UILabel!
    
    @IBOutlet weak var lblOutOfStock: UILabel!
    @IBOutlet weak var viewOutOfStock: UIView!
    
    var product: ProductDetails? {
        didSet{
            if let data = product {
                self.lblProductName.text = data.name
                self.lblCoins.text = data.coins
               discountView.isHidden = true
                
                
                self.lblProductName.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left

               
/*                var priceText = "$\(data.price ?? "")"
                if data.discount == "0" {
//                    discountView.isHidden = true
                    self.lblPrice.text = priceText
                } else {
//                    discountView.isHidden = false
//                    self.lblDiscount.text = data.discount + "% Off"
                    priceText = "$\(data.price ?? "") $\(data.totalPrice ?? "")"
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: priceText)
                    let attributeString1: NSMutableAttributedString =  NSMutableAttributedString(string: "$\(data.price ?? "")")
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString1.length))
                    self.lblPrice.attributedText = attributeString
                }
  */
                if data.discount == "0"{
                    self.lblDiscountedPrice.text = ""
                    self.lblDiscountedPrice.isHidden = true
                    self.lblPrice.text = currency.localized + " \(data.price ?? "")"
                    self.lblPriceDiscount.text = ""
                    self.lblPriceDiscount.isHidden = true
                } else {
                    self.lblDiscountedPrice.text = currency.localized + " \(data.discountedPrice ?? "")"
                    self.lblDiscountedPrice.isHidden = false
                    
                    let priceText = currency.localized + " \(data.price ?? "")"
                    self.lblPrice.text = currency.localized + " \(data.price ?? "")"
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: priceText)
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
                    self.lblPrice.attributedText = attributeString
                    
                    self.lblPriceDiscount.text = " - \(data.discount ?? "")%  "
                    self.lblPriceDiscount.isHidden = false
                }
                
                if data.status == "Out Stock".localized {
                    viewOutOfStock.isHidden = false
                }else{
                    viewOutOfStock.isHidden = true
                }
                
                // For Image
                let productsURL = NetworkEnvironment.baseImageURL + data.productImage
                if let url = URL(string: productsURL) {
                    self.imgProduct.kf.indicatorType = .activity
                    self.imgProduct.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))
//                    self.imgProduct.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"), options: nil) { result in
//                        switch result
//                        {
//                        case .success(let value):
//                            print(value)
//                           
//                        case .failure(let error):
//                            print("The error for image is \(error.localizedDescription)")
//                        }
//                    }
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        discountView.transform = CGAffineTransform(rotationAngle: CGFloat(Double(-45) * .pi/180))
        lblCoins.font = UIFont.regular(ofSize: 15)
        lblDiscount.font = UIFont.semiBold(ofSize: 13)
        lblProductName.font = UIFont.semiBold(ofSize: 16)
        lblOutOfStock.font = UIFont.bold(ofSize: 28)
        lblDiscountedPrice.font = UIFont.semiBold(ofSize: 20)
        lblPrice.font = UIFont.regular(ofSize: 14)
        lblPriceDiscount.font = UIFont.regular(ofSize: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
