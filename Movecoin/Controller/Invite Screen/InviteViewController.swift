//
//  InviteViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var btnFriends: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(isHidden: false, title: "Invite", hidesBackButton: false)
    }
    
    // ----------------------------------------------------
    // MARK: - IBAction Methods
    // ----------------------------------------------------
    
    @IBAction func btnInviteFriendsTapped(_ sender: Any) {
        self.title = "Invite"
        scrollView.setContentOffset(CGPoint(x: 0.0, y: scrollView.frame.minY), animated: true)
        btnInvite.isSelected = true
        btnFriends.isSelected = false
        btnFacebook.isSelected = false
    }
    
    @IBAction func btnFiendFriendsTapped(_ sender: Any) {
        self.title = "Find Friend"
        scrollView.setContentOffset(CGPoint(x: windowWidth, y: scrollView.frame.minY), animated: true)
        btnInvite.isSelected = false
        btnFriends.isSelected = true
        btnFacebook.isSelected = false
    }
    
    @IBAction func btnFacebookTapped(_ sender: Any) {
        self.title = "Facebook"
        scrollView.setContentOffset(CGPoint(x: (windowWidth*2), y: scrollView.frame.minY), animated: true)
        btnInvite.isSelected = false
        btnFriends.isSelected = false
        btnFacebook.isSelected = true
    }
}
