//
//  FriendTableViewCell.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

protocol FriendCellDelegate : class {
    func didPressButton(_ cell: FriendTableViewCell)
}

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var btnOutlet: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var listType = FriendsList.Unfriend
    var cellDelegate: FriendCellDelegate?
    
    var friendDetail: FriendsData? {
        didSet{
            if let detail = friendDetail {
                self.lblName.text = detail.fullName.capitalizingFirstLetter()
                self.lblNumber.text = detail.nickName
                
                // For Image
                if detail.profilePicture.isBlank {
                    self.imgPhoto.image = UIImage(named: "m-logo")
                    
                } else if let url = URL(string: detail.profilePicture) {
                    self.imgPhoto.kf.indicatorType = .activity
                    self.imgPhoto.kf.setImage(with: url, placeholder: UIImage(named: "m-logo"))
                }
            }
        }
    }
    
    var blockUserDetail: List? {
        didSet{
            if let detail = blockUserDetail {
                self.lblName.text = detail.fullName.capitalizingFirstLetter()
                self.lblNumber.text = detail.nickName
                
                // For Image
                if detail.profilePicture.isBlank {
                    self.imgPhoto.image = UIImage(named: "m-logo")
                    
                } else if let url = URL(string: detail.profilePicture) {
                    self.imgPhoto.kf.indicatorType = .activity
                    self.imgPhoto.kf.setImage(with: url, placeholder: UIImage(named: "m-logo"))
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = UIFont.semiBold(ofSize: 15)
        lblNumber.font = UIFont.regular(ofSize: 10)
        btnOutlet.titleLabel?.font = UIFont.regular(ofSize: 11)
        btnNext.isUserInteractionEnabled = false
        let sendImg = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? (UIImage(named: "arrow-right")?.imageFlippedForRightToLeftLayoutDirection()) : (UIImage(named: "arrow-right"))
        btnNext.setImage(sendImg, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch listType {
        case .TransferCoins:
            btnOutlet.setTitle("Send".localized, for: .normal)
            btnNext.isHidden = true
            break
            
        case .BlockList:
            btnOutlet.setTitle("Unblock".localized, for: .normal)
            btnNext.isHidden = true
            break
            
        case .NewChat:
            btnOutlet.isHidden = true
            btnNext.isHidden = false
            break
            
        default:
            btnOutlet.setTitle("Unfriend".localized, for: .normal)
            btnNext.isHidden = true
            break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func btnAction(_ sender: Any) {
        cellDelegate?.didPressButton(self)
    }
}
