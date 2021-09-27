//
//  PurchaseHistoryTableViewCell.swift
//  Movecoin
//
//  Created by eww090 on 16/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class PurchaseHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var lblPaymentStatus: LocalizLabel!
    
    var orderDetail: History? {
        didSet{
            if let detail = orderDetail {
                self.lblPrice.text = detail.coins
                self.lblTitle.text = detail.name.capitalizingFirstLetter()
                self.lblPaymentStatus.textColor = .white
                if let dateStr = UtilityClass.changeDateFormateFrom(dateString: detail.createdAt, fromFormat: DateFomateKeys.offerPurchased, withFormat: DateFomateKeys.displayDate) {
                     self.lblDate.text =  dateStr
                }
                let productsURL = NetworkEnvironment.baseImageURL + detail.image
                if let url = URL(string: productsURL) {
                    self.imgPhoto.kf.indicatorType = .activity
                    self.imgPhoto.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = UIFont.regular(ofSize: 15)
        lblDate.font = UIFont.regular(ofSize: 12)
        lblPrice.font = UIFont.regular(ofSize: 15)
        lblPaymentStatus.font = UIFont.regular(ofSize: 11)
        let arrowImg = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? (UIImage(named: "arrow-right")?.imageFlippedForRightToLeftLayoutDirection()) : (UIImage(named: "arrow-right"))
        btnArrow.setImage(arrowImg, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imgPhoto.layer.cornerRadius = self.imgPhoto.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
