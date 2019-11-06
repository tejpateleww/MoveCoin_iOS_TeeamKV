//
//  TotalStepsTableViewCell.swift
//  Movecoin
//
//  Created by eww090 on 07/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class TotalStepsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblSteps: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblDate.font = UIFont.regular(ofSize: 15)
        lblSteps.font = UIFont.regular(ofSize: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
