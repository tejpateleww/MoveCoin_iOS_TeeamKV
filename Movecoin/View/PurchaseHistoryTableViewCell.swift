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
    
    var orderDetail: Order? {
        didSet{
            if let detail = orderDetail {
                
                self.lblPrice.text = detail.coins
                self.lblTitle.text = detail.productName.capitalizingFirstLetter()
                
//                self.lblPaymentStatus.isHidden = detail.paymentStatus == "failed" ? false : true
                
                let status = detail.orderStatus//PaymentStatus(rawValue: detail.orderStatus.capitalizingFirstLetter())
                self.lblPaymentStatus.text = status?.capitalizingFirstLetter()//(status?.rawValue)?.localized
                self.lblPaymentStatus.textColor = .white
                
                
//                if(status == .Failed)
//                {
//                    self.lblPaymentStatus.textColor = .red
//                }
//                switch status {
//                case .Success:
////                    self.lblPaymentStatus.textColor = .green
//                case .Failed:
////                    self.lblPaymentStatus.textColor = .red
//                case .Pending:
////                    self.lblPaymentStatus.textColor = .orange
//                case .Placed:
////                    self.lblPaymentStatus.textColor = .blue
//                case .none:
////                    self.lblPaymentStatus.text = "Pending".localized
////                    self.lblPaymentStatus.textColor = .orange
//                }
                
//                if detail.discount != "0" {
//                    self.lblTitle.text = detail.productName.capitalizingFirstLetter() + " with \(detail.discount!)% Discount"
//                }else {
//                    self.lblTitle.text = detail.productName.capitalizingFirstLetter()
//                }
                if let dateStr = UtilityClass.changeDateFormateFrom(dateString: detail.orderDate, fromFormat: DateFomateKeys.api, withFormat: DateFomateKeys.displayDateTime) {
                     self.lblDate.text =  dateStr
                }
                let productsURL = NetworkEnvironment.baseImageURL + detail.productImage
                if let url = URL(string: productsURL) {
                    self.imgPhoto.kf.indicatorType = .activity
                    self.imgPhoto.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = UIFont.semiBold(ofSize: 15)
        lblDate.font = UIFont.regular(ofSize: 12)
        lblPrice.font = UIFont.regular(ofSize: 15)
        lblPaymentStatus.font = UIFont.bold(ofSize: 11)
        let arrowImg = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? (UIImage(named: "arrow-right")?.imageFlippedForRightToLeftLayoutDirection()) : (UIImage(named: "arrow-right"))
        btnArrow.setImage(arrowImg, for: .normal)
        lblPaymentStatus.text = "FAILED".localized
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imgPhoto.layer.cornerRadius = self.imgPhoto.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
