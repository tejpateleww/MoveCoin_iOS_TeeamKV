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


class FacebookFriend : Codable, Comparable {
    
    var firstName : String!
    var iD : String!
    var lastName : String!
  
    
    init(){
        
    }
    
    static func < (lhs: FacebookFriend, rhs: FacebookFriend) -> Bool {
        return lhs.firstName.capitalizingFirstLetter() < rhs.firstName.capitalizingFirstLetter()
    }
    
    static func == (lhs: FacebookFriend, rhs: FacebookFriend) -> Bool {
        return lhs.firstName == rhs.firstName
    }
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromDictionary dic: [String:Any]){
       
        firstName = dic["first_name"] as? String
        iD = dic["id"] as? String
        lastName = dic["last_name"] as? String
    }
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
//                self.lblNumber.text = detail.phone
                self.lblNumber.isHidden = false
                if let type = RequestType(rawValue: detail.type) {
                    self.lblNumber.text = "From : ".localized + type.requestTypeString()
                } else {
                    self.lblNumber.text = "-"
                }
                
                if detail.nickName.isBlank {
                    lblNickName.isHidden = true
                }else{
                    lblNickName.isHidden = false
                    self.lblNickName.text = detail.nickName.capitalizingFirstLetter()
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
                
                if lblName.text?.isBlank ?? true { return }
                if lblName.text != "" {
                    self.lblFirstCharacter.text = String(lblName.text?.first ?? Character(""))
                }
            }
        }
    }
    
    var notRegisteredFriend: PhoneModel? {
        didSet{
            btnAccept.isHidden = true
            lblNickName.isHidden = true
            lblNumber.isHidden = false
            
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
                self.lblNumber.isHidden = false
                
                if lblName.text?.isBlank ?? true { return }
                self.lblFirstCharacter.text = String(lblName.text?.first ?? Character(""))
            }
        }
    }
    
    var fbFriend: User? {
        didSet {
            btnAccept.isHidden = true
            lblNickName.isHidden = true
            lblNumber.isHidden = true
            btnInvite.setTitle("Add Friend".localized, for: .normal)
            btnInvite.titleLabel?.font = UIFont.regular(ofSize: 12)
            
            guard let data = fbFriend else { return }
            
            if data.isFriend == "0" {
                btnInvite.setTitle("Add Friend".localized, for: .normal)
                btnInvite.isUserInteractionEnabled = true
            } else {
                if (data.isFriend == "1") && (data.senderID != SingletonClass.SharedInstance.userData?.iD ?? "") {
                    btnInvite.setTitle("Respond".localized, for: .normal)
                    btnInvite.isUserInteractionEnabled = true
                } else {
                    btnInvite.setTitle("Requested".localized, for: .normal)
                    btnInvite.isUserInteractionEnabled = false
                }
            }
            
            if data.nickname.isBlank  {
                lblNickName.isHidden = true
            }else{
                lblNickName.isHidden = false
                self.lblNickName.text = data.nickname.capitalizingFirstLetter()
            }
        
//            let fullname = "\(data.firstName ?? "") \(data.lastName ?? "")"
            self.lblName.text = data.fullname.capitalizingFirstLetter()
            if lblName.text?.isBlank ?? true { return }
            self.lblFirstCharacter.text = String(lblName.text?.first ?? Character(""))
        }
    }
    
    var searchFriend: SearchData? {
        didSet {
            lblNumber.isHidden = true
            btnAccept.isHidden = true
            btnInvite.titleLabel?.font = UIFont.regular(ofSize: 12)
            
            guard let data = searchFriend else { return }
            
            if data.nickName.isBlank  {
                lblNickName.isHidden = true
            }else{
                lblNickName.isHidden = false
                self.lblNickName.text = data.nickName.capitalizingFirstLetter()
            }
            
            self.lblNumber.text = data.phone
            
            if data.isFriend == "0" {
                btnInvite.setTitle("Add Friend".localized, for: .normal)
                btnInvite.isUserInteractionEnabled = true
            } else {
                if (data.isFriend == "1") && (data.senderID != SingletonClass.SharedInstance.userData?.iD ?? "") {
                    btnInvite.setTitle("Respond".localized, for: .normal)
                    btnInvite.isUserInteractionEnabled = true
                } else {
                    btnInvite.setTitle("Requested".localized, for: .normal)
                    btnInvite.isUserInteractionEnabled = false
                }
            }
            
            self.lblName.text = data.fullName.capitalizingFirstLetter()
            if lblName.text?.isBlank ?? true { return }
            self.lblFirstCharacter.text = String(lblName.text?.first ?? Character(""))
            
            
//            btnInvite.isHidden = (data.isFriend == "0") ? false : true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lblName.font = UIFont.semiBold(ofSize: 18)
        lblNickName.font = UIFont.regular(ofSize: 12)
        lblNumber.font = UIFont.regular(ofSize: 13)
        lblFirstCharacter.font = UIFont.light(ofSize: 24)
        btnInvite.titleLabel?.font = UIFont.regular(ofSize: 13)
        btnAccept.titleLabel?.font = UIFont.regular(ofSize: 13)
        btnInvite.isUserInteractionEnabled = true
    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        lblName.font = UIFont.semiBold(ofSize: 18)
//        lblNickName.font = UIFont.regular(ofSize: 12)
//        lblNumber.font = UIFont.regular(ofSize: 13)
//        lblFirstCharacter.font = UIFont.light(ofSize: 24)
//        btnInvite.titleLabel?.font = UIFont.regular(ofSize: 13)
//        btnAccept.titleLabel?.font = UIFont.regular(ofSize: 13)
//        btnInvite.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnAction(_ sender: Any) {
        cellDelegate?.didPressButton(self)
    }
}
