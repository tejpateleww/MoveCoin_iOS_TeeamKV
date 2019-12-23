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
    
    var friendDetail: ChatList? {
        didSet{
            if let detail = friendDetail {
                self.lblName.text = detail.fullName.capitalizingFirstLetter()
                self.lblId.text = UtilityClass.changeDateFormateFrom(dateString: detail.lastMessageDate, fromFormat: DateFomateKeys.api, withFormat: DateFomateKeys.displayFullDate)
                // For Image
//                let urlStr = NetworkEnvironment.baseImageURL + detail.profilePicture
                 if let url = URL(string: detail.profilePicture) {
                     self.imgPhoto.kf.indicatorType = .activity
                     self.imgPhoto.kf.setImage(with: url)
                 }
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
