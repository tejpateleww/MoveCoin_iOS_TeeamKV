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
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var btnArrow: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = UIFont.regular(ofSize: 17)
        let sendImg = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? (UIImage(named: "arrow-right")?.imageFlippedForRightToLeftLayoutDirection()) : (UIImage(named: "arrow-right"))
        btnArrow.setImage(sendImg, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
