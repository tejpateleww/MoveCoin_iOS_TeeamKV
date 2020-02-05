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
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var btnFriends: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var subview: UIView!

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    lazy var isFromNotification : Bool = false
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
//        localizeUI(parentView: self.viewParent)
        if Localize.currentLanguage() == Languages.Arabic.rawValue {
            self.scrollView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
            self.subview.transform =  CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
        if isFromNotification {
            btnFiendFriendsTapped(btnFriends as Any)
            for controller in self.children {
                if controller.isKind(of: FindFriendsViewController.self) {
                    (controller as! FindFriendsViewController).accessContacts()
                }
            }
        } else{
            if !btnFacebook.isSelected {
                loadThePage(sender: btnInvite)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.view.contentOffset = self.scrollView.contentOffset;
        if !btnFacebook.isSelected {
            self.scrollView.contentOffset = CGPoint.zero
        }
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func loadThePage(sender : UIButton){
        sender.isSelected = true
        if btnInvite.isSelected {
            self.navigationBarSetUp(title: "Invite".localized)
        }else if btnFriends.isSelected {
             self.navigationBarSetUp(title: "Find Friend".localized)
        }else if btnFacebook.isSelected {
             self.navigationBarSetUp(title: "Facebook".localized)
        }
    }
    func scrollToPage(page: Int) {
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = (windowWidth) * CGFloat(page)
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnInviteFriendsTapped(_ sender: Any) {
        self.title = "Invite".localized
//        scrollToPage(page: 0)
        print("setContentOffset : \(scrollView.contentOffset)")
        self.scrollView.setContentOffset(CGPoint(x: 0.0, y: self.scrollView.frame.minY), animated: true)
        self.scrollView.scrollRectToVisible(CGRect(), animated: true)
        print("setContentOffset : \(scrollView.contentOffset)")
        btnInvite.isSelected = true
        btnFriends.isSelected = false
        btnFacebook.isSelected = false
    }
    
    @IBAction func btnFiendFriendsTapped(_ sender: Any) {
        self.title = "Find Friend".localized
//        scrollToPage(page: 1)
        print("setContentOffset : \(scrollView.contentOffset)")
        scrollView.setContentOffset(CGPoint(x: windowWidth, y: scrollView.frame.minY), animated: true)
        print("setContentOffset : \(scrollView.contentOffset)")
        btnInvite.isSelected = false
        btnFriends.isSelected = true
        btnFacebook.isSelected = false
    }
    
    @IBAction func btnFacebookTapped(_ sender: Any) {
        self.title = "Facebook".localized
//        scrollToPage(page: 2)
        print("setContentOffset : \(scrollView.contentOffset)")
        scrollView.setContentOffset(CGPoint(x: (windowWidth*2), y: scrollView.frame.minY), animated: true)
        print("setContentOffset : \(scrollView.contentOffset)")
        btnInvite.isSelected = false
        btnFriends.isSelected = false
        btnFacebook.isSelected = true
    }
}

