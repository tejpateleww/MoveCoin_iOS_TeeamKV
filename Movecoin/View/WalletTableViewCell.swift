//
//  WalletTableViewCell.swift
//  Movecoin
//
//  Created by eww090 on 05/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class WalletTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDiscription: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var darkOverlayView: UIView?

    var walletDetail: WalletData? {
        didSet{
            if let detail = walletDetail {
                self.lblDiscription.text = detail.descriptionField
                self.lblMessage.text = detail.message
                self.lblMessage.isHidden = detail.message.isBlank ? true : false
                
                if let dateStr = UtilityClass.changeDateFormateFrom(dateString: detail.createdDate, fromFormat: DateFomateKeys.api, withFormat: DateFomateKeys.displayDate){
                    self.lblDate.text = dateStr
                }
                
                self.darkOverlayView?.isHidden = true
                if(detail.isRead == "1")
                {
                    self.darkOverlayView?.isHidden = false
                }
                
                let type = CoinsTransferType.init(rawValue: detail.type)
                switch type {
                case .Send, .Redeem:
                    self.lblAmount.text = "-" + detail.coins
                    self.imgIcon.image = UIImage(named: "logo-green-small")
                    self.darkOverlayView?.isHidden = false
                case .Receive:
                    self.lblAmount.text = "+" + detail.coins
                    self.imgIcon.image = UIImage(named: "logo-green-small")
                    self.darkOverlayView?.isHidden = false
                case .RedeemOffer:
                    self.lblAmount.text = "-" + detail.coins
                    self.imgIcon.image = UIImage(named: "iconBasket")
                case .none:
                    return
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        lblAmount.font = UIFont.regular(ofSize: 17)
        lblDiscription.font = UIFont.regular(ofSize: 17)
        lblDate.font = UIFont.light(ofSize: 11)
        lblMessage.font = UIFont.regular(ofSize: 13)
//        if lblDiscription.textAlignment == .right || lblDiscription.textAlignment == .left {
            lblDiscription.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
            lblMessage.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
            lblDate.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
            lblAmount.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .left : .right
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
