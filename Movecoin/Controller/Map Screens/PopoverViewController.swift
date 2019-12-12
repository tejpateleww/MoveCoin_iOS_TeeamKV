//
//  PopoverViewController.swift
//  Movecoin
//
//  Created by eww090 on 15/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

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
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let parent = self.parent as? MapViewController {
            parent.delegateFriendStatus = self
        }
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        if let parent = self.parent as? MapViewController {
            parent.toggleHandler(isOn: false)
        }
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
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnChatTapped(_ sender: Any) {
        if let parent = self.parent as? MapViewController {
            print(parent.parent!)
            if let parentVC = parent.parent as? TabViewController {
                let storyBoard = UIStoryboard(name: "ChatStoryboard", bundle: nil)
                let destination = storyBoard.instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
                parentVC.navigationController?.pushViewController(destination, animated: true)
            }
        }
    }
    
    @IBAction func btntransferTapped(_ sender: Any) {
        if let parent = self.parent as? MapViewController {
            print(parent.parent!)
           if let parentVC = parent.parent as? TabViewController {
                let destination = parentVC.storyboard?.instantiateViewController(withIdentifier: TransferMoveCoinsViewController.className) as! TransferMoveCoinsViewController
                parentVC.navigationController?.pushViewController(destination, animated: true)
            }
        }
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
