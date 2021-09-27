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
    @IBOutlet weak var btnBadge: UIButton!
    @IBOutlet weak var btnArrow: UIButton!
    
    var friendDetail: ChatList? {
        didSet{
            if let detail = friendDetail {
                self.lblName.text = detail.nickName//.capitalizingFirstLetter()
                self.lblId.text = UtilityClass.changeDateFormateFrom(dateString: detail.lastMessageDate, fromFormat: DateFomateKeys.api, withFormat: DateFomateKeys.displayFullDate)
                // For Image
                //                let urlStr = NetworkEnvironment.baseImageURL + detail.profilePicture
                if let url = URL(string: detail.profilePicture) {
                    self.imgPhoto.kf.indicatorType = .activity
                    self.imgPhoto.kf.setImage(with: url, placeholder: UIImage(named: "m-logo"))
                } else if detail.profilePicture == "" {
                    self.imgPhoto.image = UIImage(named: "m-logo")
                }
                if detail.unreadMsgCount != "0" {
                    btnBadge.isHidden = false
                    btnBadge.setTitle(detail.unreadMsgCount, for: .normal)
                } else{
                    btnBadge.isHidden = true
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = UIFont.regular(ofSize: 15)
        lblId.font = UIFont.regular(ofSize: 12)
        btnBadge.titleLabel?.font = UIFont.regular(ofSize: 10)
        btnBadge.cornerRadius = btnBadge.frame.height / 2
        let sendImg = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? (UIImage(named: "arrow-right")?.imageFlippedForRightToLeftLayoutDirection()) : (UIImage(named: "arrow-right"))
        btnArrow.setImage(sendImg, for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
