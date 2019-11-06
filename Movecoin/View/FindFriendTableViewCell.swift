//
//  FindFriendTableViewCell.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class FindFriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblFirstCharacter: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var btnInvite: UIButton!
    
    var friendDetail: FriendDetail? {
        didSet{
            if let detail = friendDetail {
                self.lblName.text = detail.name.capitalizingFirstLetter()
                self.lblNumber.text = detail.number
                self.lblFirstCharacter.text = String(lblName.text?.first ?? Character(""))
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = UIFont.semiBold(ofSize: 18)
        lblNumber.font = UIFont.regular(ofSize: 13)
        lblFirstCharacter.font = UIFont.light(ofSize: 24)
        btnInvite.titleLabel?.font = UIFont.regular(ofSize: 13)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
