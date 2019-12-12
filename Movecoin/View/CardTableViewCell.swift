//
//  CardTableViewCell.swift
//  Movecoins
//
//  Created by eww090 on 14/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit


class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblnumber: UILabel!
    
    var cardDetail: Card? {
        didSet{
            if let detail = cardDetail {
                self.lblName.text = detail.alias
                self.lblnumber.text =  detail.cardNum // "XXXX XXXX XXXX " + String(detail.cardNum.suffix(4))
                let type = detail.type.lowercased()
                self.imgCard.image = UIImage(named: type)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = UIFont.semiBold(ofSize: 17)
        lblnumber.font = UIFont.regular(ofSize: 18)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
