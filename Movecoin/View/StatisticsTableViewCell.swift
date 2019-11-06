//
//  StatisticsTableViewCell.swift
//  Movecoin
//
//  Created by eww090 on 05/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblSteps: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblSteps.font = UIFont.regular(ofSize: 15)
        lblPoints.font = UIFont.regular(ofSize: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
