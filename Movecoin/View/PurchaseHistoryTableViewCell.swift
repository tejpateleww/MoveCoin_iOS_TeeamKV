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
    
//    var friendDetail: FriendDetail? {
//        didSet{
//            if let detail = friendDetail {
//                self.lblName.text = detail.name.capitalizingFirstLetter()
//                self.lblId.text = detail.number
//
//            }
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = UIFont.semiBold(ofSize: 15)
        lblDate.font = UIFont.regular(ofSize: 12)
        lblPrice.font = UIFont.regular(ofSize: 15)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imgPhoto.layer.cornerRadius = self.imgPhoto.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
