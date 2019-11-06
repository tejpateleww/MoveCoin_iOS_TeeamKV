//
//  FriendTableViewCell.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var btnOutlet: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var listType = FriendsList.FollowUnfollow
    
    var friendDetail: FriendDetail? {
        didSet{
            if let detail = friendDetail {
                self.lblName.text = detail.name.capitalizingFirstLetter()
                self.lblNumber.text = detail.number
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
            btnOutlet.setTitle("Unfollow", for: .normal)
            btnNext.isHidden = true
            break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    @IBAction func btnAction(_ sender: Any) {
        
        switch listType {
            
        case .TransferCoins:
            print("Send")
            guard let parentVC = self.parentContainerViewController() else { return }
            let destination = parentVC.storyboard?.instantiateViewController(withIdentifier: TransferMoveCoinsViewController.className) as! TransferMoveCoinsViewController
            (parentVC as! FriendsViewController).navigationController?.pushViewController(destination, animated: true)
            break
            
        case .NewChat:
            print("NewChat")
            break
            
        default:
            print("Unfollow")
            break
        }
    }
}
