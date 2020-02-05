//
//  SettingsTableViewCell.swift
//  Movecoin
//
//  Created by eww090 on 12/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var switchToggle: UISwitch!
    @IBOutlet weak var btnArrow: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = UIFont.regular(ofSize: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
