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
                if detail.profilePicture.isBlank{
                    return
                }
                let urlStr = NetworkEnvironment.baseImageURL + detail.profilePicture
                if let url = URL(string: urlStr) {
                    self.imgPhoto.kf.indicatorType = .activity
                    self.imgPhoto.kf.setImage(with: url)
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch listType {
        case .TransferCoins:
            btnOutlet.setTitle("Send", for: .normal)
            btnNext.isHidden = true
            break
        case .NewChat:
            btnOutlet.isHidden = true
            btnNext.isHidden = false
            break
        default:
            btnOutlet.setTitle("Unfriend", for: .normal)
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
