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
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    var walletDetail: WalletData? {
        didSet{
            if let detail = walletDetail {
                self.lblDiscription.text = detail.descriptionField
                
                if let dateStr = UtilityClass.changeDateFormateFrom(dateString: detail.createdDate, fromFormat: DateFomateKeys.api, withFormat: DateFomateKeys.displayDate){
                    self.lblDate.text = dateStr
                }
                
                let type = CoinsTransferType.init(rawValue: detail.type)
                switch type {
                case .Send, .Redeem:
                    self.lblAmount.text = "-" + detail.coins
                case .Receive:
                    self.lblAmount.text = "+" + detail.coins
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
