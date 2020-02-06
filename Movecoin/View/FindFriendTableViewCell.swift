//
//  FindFriendTableViewCell.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

protocol InviteFriendCellDelegate : class {
    func didPressButton(_ cell: FindFriendTableViewCell)
}

class FindFriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblFirstCharacter: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    
    var type : FriendsStatus?
    var cellDelegate: InviteFriendCellDelegate?
    
    var requested: Request? {
        didSet{
//            btnInvite.titleLabel?.font = UIFont.regular(ofSize: 12)
            
            if let detail = requested {
                self.lblName.text = detail.fullName.capitalizingFirstLetter()
                self.lblNumber.text = detail.phone
                
                if detail.nickName.isBlank {
                    lblNickName.isHidden = true
                }else{
                    lblNickName.isHidden = false
                    self.lblNickName.text = detail.nickName.capitalizingFirstLetter()
                }
                if lblName.text?.isBlank ?? true { return }
                if lblName.text != "" {
                    self.lblFirstCharacter.text = String(lblName.text?.first ?? Character(""))
                }
                
                if detail.receiverID == SingletonClass.SharedInstance.userData?.iD {
                    btnInvite.setTitle("Reject".localized, for: .normal)
                    btnAccept.setTitle("Accept".localized, for: .normal)
                    btnAccept.isHidden = false
                } else if detail.senderID == SingletonClass.SharedInstance.userData?.iD {
                    btnInvite.titleLabel?.font = UIFont.regular(ofSize: 12)
                    btnInvite.setTitle("Requested".localized, for: .normal)
                    btnInvite.isUserInteractionEnabled = false
                    btnAccept.isHidden = true
                }
            }
        }
    }
    
    var notRegisteredFriend: PhoneModel? {
        didSet{
            btnAccept.isHidden = true
            lblNickName.isHidden = true
            btnInvite.setTitle("+ Invite".localized, for: .normal)
            if let detail = notRegisteredFriend {
                self.lblName.text = detail.name.trimmingCharacters(in: .whitespacesAndNewlines).capitalizingFirstLetter()
                self.lblNumber.text = detail.number
                if lblName.text?.isBlank ?? true { return }
                self.lblFirstCharacter.text = String(lblName.text?.first ?? Character(""))
            }
        }
    }
    
    var registeredFriend: Registered? {
        didSet{
            btnAccept.isHidden = true
            btnInvite.setTitle("Add Friend".localized, for: .normal)
            btnInvite.titleLabel?.font = UIFont.regular(ofSize: 12)
            if let detail = registeredFriend {
                if detail.fullName != "" {
                    self.lblName.text = detail.fullName.capitalizingFirstLetter()
                } else {
                     self.lblName.text = detail.nickName.capitalizingFirstLetter()
                }
                if detail.nickName.isBlank {
                    lblNickName.isHidden = true
                }else{
                    lblNickName.isHidden = false
                    self.lblNickName.text = detail.nickName.capitalizingFirstLetter()
                }
                self.lblNumber.text = detail.phone
                if lblName.text?.isBlank ?? true { return }
                self.lblFirstCharacter.text = String(lblName.text?.first ?? Character(""))
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = UIFont.semiBold(ofSize: 18)
        lblNickName.font = UIFont.regular(ofSize: 12)
        lblNumber.font = UIFont.regular(ofSize: 13)
        lblFirstCharacter.font = UIFont.light(ofSize: 24)
        btnInvite.titleLabel?.font = UIFont.regular(ofSize: 13)
        btnAccept.titleLabel?.font = UIFont.regular(ofSize: 13)
        btnInvite.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnAction(_ sender: Any) {
        cellDelegate?.didPressButton(self)
    }
}
