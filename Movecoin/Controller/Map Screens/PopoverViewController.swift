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
    @IBOutlet weak var btnSendFriendRequest: ThemeButton!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        btnSendFriendRequest.isHidden = true
        stackButtons.isHidden = true
        stackInfo.isHidden = true
        
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
    
    func setupUserData(){
        btnSendFriendRequest.isUserInteractionEnabled = true
        
        lblName.text = userData.fullName
        lblMemberSince.text = "Member Since " + userData.memberSince
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
            
            lblLastSeen.text = "Last seen " + userData.lastSeen
            lblTotalSteps.text = userData.steps
            
        } else {
            // Not Friend
            btnSendFriendRequest.isHidden = false
            stackButtons.isHidden = true
            stackInfo.isHidden = true
            lblLastSeen.isHidden = true
            if userData.isFriend == 0 {
                btnSendFriendRequest.setTitle("Requested", for: .normal)
                btnSendFriendRequest.isUserInteractionEnabled = false
            }else {
                btnSendFriendRequest.setTitle("Add Friend", for: .normal)
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
//            destination.receiverData
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

        FriendsWebserviceSubclass.friendRequest(frinedRequestModel: requestModel){ (json, status, res) in
            UtilityClass.hideHUD()
            if status {
                UtilityClass.showAlert(Message: json["message"].stringValue)
                self.btnSendFriendRequest.setTitle("Requested", for: .normal)
                self.btnSendFriendRequest.isUserInteractionEnabled = false
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
