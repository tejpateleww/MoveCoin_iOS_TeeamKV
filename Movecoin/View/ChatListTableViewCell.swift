//
//  ChatListTableViewCell.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblId: UILabel!
    
    var friendDetail: FriendDetail? {
        didSet{
            if let detail = friendDetail {
                self.lblName.text = detail.name.capitalizingFirstLetter()
                self.lblId.text = detail.number
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = UIFont.semiBold(ofSize: 15)
        lblId.font = UIFont.regular(ofSize: 10)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
