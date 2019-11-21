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
    
    var cardDetail: CardDetail? {
        didSet{
            if let detail = cardDetail {
                self.lblName.text = detail.name
                self.lblnumber.text = "XXXX XXXX XXXX " + String(detail.number.suffix(4))
                self.imgCard.image = UIImage(named: detail.image)
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
