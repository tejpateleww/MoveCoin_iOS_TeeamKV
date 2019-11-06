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
    
    var walletDetail: WalletDetail? {
        didSet{
            if let detail = walletDetail {
                self.lblDiscription.text = detail.discription
                self.lblAmount.text = detail.amount
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
