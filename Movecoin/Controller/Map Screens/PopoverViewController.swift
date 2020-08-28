//
//  PopoverViewController.swift
//  Movecoin
//
//  Created by eww090 on 15/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import MapKit

class PopoverViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLastSeen: UILabel!
    @IBOutlet weak var lblMemberSince: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTotalSteps: UILabel!
    @IBOutlet weak var lblChat: UILabel!
    @IBOutlet weak var lblTransfer: UILabel!
    
    @IBOutlet weak var stackInfo: UIStackView!
    @IBOutlet weak var stackButtons: UIStackView!
    @IBOutlet weak var btnSendFriendRequest: UIButton!
    
    // ----------------------------------------------------
    //MARK:- --------- Variables ---------
    // ----------------------------------------------------
    
    var userData : UserDetail!
    var annotationView : MKAnnotationView!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.setupFont()
        setButtonLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        btnSendFriendRequest.isHidden = true
        stackButtons.isHidden = true
        stackInfo.isHidden = true
        localizeSetup()
        
        if let parent = self.parent as? MapViewController {
            parent.delegateFriendStatus = self
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        btnCloseTapped(UIButton.self)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setupFont(){
        lblChat.font = UIFont.semiBold(ofSize: 16)
        lblTransfer.font = UIFont.semiBold(ofSize: 16)
        lblName.font = UIFont.semiBold(ofSize: 16)
        lblLastSeen.font = UIFont.regular(ofSize: 12)
        lblMemberSince.font = UIFont.regular(ofSize: 12)
        lblTime.font = UIFont.regular(ofSize: 12)
        lblTotalSteps.font = UIFont.regular(ofSize: 12)
    }
    
    func setButtonLayout() {
        btnSendFriendRequest.backgroundColor = .init(white: 1.0, alpha: 0.23)
        btnSendFriendRequest.setTitleColor(.white, for: .normal)
        btnSendFriendRequest.layer.cornerRadius = btnSendFriendRequest.frame.size.height / 2
        btnSendFriendRequest.layer.masksToBounds = true
        btnSendFriendRequest.titleLabel?.font = UIFont(name: FontBook.SemiBold.rawValue, size: 20.0)
    }
    
    func localizeSetup(){
        lblChat.text = "Chat".localized
        lblTime.text = "Today".localized
        lblTransfer.text = "Transfer".localized
        lblName.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        lblLastSeen.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        lblMemberSince.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
    }
    
    func setupUserData(){
        btnSendFriendRequest.isUserInteractionEnabled = true
        
        lblName.text = userData.fullName
        lblMemberSince.text = "Member since ".localized + userData.memberSince
//        let productsURL = NetworkEnvironment.baseImageURL + userData.profilePicture
        if let url = URL(string: userData.profilePicture) {
            self.imgProfile.kf.indicatorType = .activity
            self.imgProfile.kf.setImage(with: url, placeholder: imgProfile.image)
        }
        
        if userData.isFriend == 1 {
            // Friend
            btnSendFriendRequest.isHidden = true
            stackButtons.isHidden = false
            stackInfo.isHidden = false
            lblLastSeen.isHidden = false
            
            lblLastSeen.text = "Last seen ".localized + userData.lastSeen
            lblTotalSteps.text = userData.steps
            
        } else {
            // Not Friend
            btnSendFriendRequest.isHidden = false
            stackButtons.isHidden = true
            stackInfo.isHidden = true
            lblLastSeen.isHidden = true
            if userData.isFriend == 0 {
                btnSendFriendRequest.setTitle("Requested".localized, for: .normal)
                btnSendFriendRequest.isUserInteractionEnabled = false
            }else {
                btnSendFriendRequest.setTitle("Add Friend".localized, for: .normal)
            }
        }
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        if let parent = self.parent as? MapViewController {
            parent.toggleHandler(isOn: false, user: nil, annotationView: nil)
//            parent.mapView(parent.mapView, didDeselect: annotationView)
        }
    }
    
    @IBAction func btnChatTapped(_ sender: Any) {
        if let parent = self.parent as? MapViewController {
            print(parent.parent!)
            if let parentVC = parent.parent as? TabViewController {
                let storyBoard = UIStoryboard(name: "ChatStoryboard", bundle: nil)
                let destination = storyBoard.instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
                destination.receiverID = userData.iD
                parentVC.navigationController?.pushViewController(destination, animated: true)
            }
        }
    }
    
    @IBAction func btntransferTapped(_ sender: Any) {
        if let parent = self.parent as? MapViewController {
            print(parent.parent!)
           if let parentVC = parent.parent as? TabViewController {
                let destination = parentVC.storyboard?.instantiateViewController(withIdentifier: TransferMoveCoinsViewController.className) as! TransferMoveCoinsViewController
                destination.receiverID = userData.iD
                destination.receiverName = userData.fullName
                parentVC.navigationController?.pushViewController(destination, animated: true)
            }
        }
    }
    
    @IBAction func btnAddFriendTapped(_ sender: Any) {
//        if let recevierID = cell.registeredFriend?.iD {
            webserviceForAddFriends()
//        }
    }
}

// ----------------------------------------------------
//MARK:- --------- Custom Delegate Methods ---------
// ----------------------------------------------------

extension PopoverViewController : FriendStatusDelegate {
    
    func checkFriendStatus(status: FriendsStatus) {
        
        switch status {
        case .AlreadyFriend:
            btnSendFriendRequest.isHidden = true
            stackButtons.isHidden = false
            stackInfo.isHidden = false
            lblLastSeen.isHidden = false
            
        case .RecommendedFriend:
            btnSendFriendRequest.isHidden = false
            stackButtons.isHidden = true
            stackInfo.isHidden = true
            lblLastSeen.isHidden = true
           
        default :
            return
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension PopoverViewController {
    
    func webserviceForNearByUserDetails(user : Nearbyuser){
        
        let requestModel = NearByUserDetailModel()
        requestModel.user_id = SingletonClass.SharedInstance.userData?.iD ?? ""
        requestModel.friend_id = user.userID

        FriendsWebserviceSubclass.nearByUsersDetails(nearByUsersDetailsModel: requestModel){ (json, status, res) in
            
            if status {
                let responseModel = NearByUserDetailResponseModel(fromJson: json)
                self.userData = responseModel.userDetail
                self.setupUserData()
                
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func webserviceForAddFriends(){
        UtilityClass.showHUD()
        let requestModel = FriendRequestModel()
        requestModel.SenderID = SingletonClass.SharedInstance.userData?.iD ?? ""
        requestModel.ReceiverID = userData.iD
        requestModel.type = "3" // For map

        FriendsWebserviceSubclass.friendRequest(friendRequestModel: requestModel){ (json, status, res) in
            UtilityClass.hideHUD()
            if status {
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
                UtilityClass.showAlert(Message: msg)
                self.btnSendFriendRequest.setTitle("Requested".localized, for: .normal)
                self.btnSendFriendRequest.isUserInteractionEnabled = false
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
