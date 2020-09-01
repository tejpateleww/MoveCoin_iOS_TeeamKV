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
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var imgStar: UIImageView!

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    lazy var isFromNotification : Bool = false
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgStar.isHidden = true
        imgStar.tintColor = .white
        imgStar.image = imgStar.image?.withRenderingMode(.alwaysTemplate)
      
        if Localize.currentLanguage() == Languages.Arabic.rawValue {
            self.scrollView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
            self.subview.transform =  CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        }
        
        viewParent.semanticContentAttribute = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .forceRightToLeft : .forceLeftToRight
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
        if isFromNotification {
            loadThePage(sender: btnFriends)
            btnFiendFriendsTapped(btnFriends as Any)
            for controller in self.children {
                if controller.isKind(of: FindFriendsViewController.self) {
                    (controller as! FindFriendsViewController).accessContacts()
                }
            }
        } else{
            if btnFacebook.isSelected {
                self.navigationBarSetUp(title: "Facebook".localized)
            }else {
                loadThePage(sender: btnInvite)
                btnFriends.isSelected = false
                btnFacebook.isSelected = false
                btnSearch.isSelected = false
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
        }else if btnSearch.isSelected {
            self.navigationBarSetUp(title: "Search".localized)
        }
    }
    
    func scrollToPage(page: Int) {
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = (windowWidth) * CGFloat(page)
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: false)
        
        for controller in self.children {
            controller.view.endEditing(true)
        }
    }
    
    func refreshAllFriendsList() {
        
        for child in self.children {
            // For refreshing the Find Friends list
            if child.isKind(of: FindFriendsViewController.self) {
                let findFriendVC = child as! FindFriendsViewController
                findFriendVC.retrieveContacts(from: findFriendVC.store)
            }
            
            // For refreshing FB Friends list
            if child.isKind(of: FacebookViewController.self) {
                let fbVC = child as! FacebookViewController
                if UserDefaults.standard.string(forKey: UserDefaultKeys.kFacebookID) != nil {
                    fbVC.webserviceForInviteFriends(dic: fbVC.getFBfriendsArray)
                }
            }
        }
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnInviteFriendsTapped(_ sender: Any) {
        self.title = "Invite".localized
       scrollToPage(page: 0)
//        print("setContentOffset : \(scrollView.contentOffset)")
        self.scrollView.setContentOffset(CGPoint(x: 0.0, y: self.scrollView.frame.minY), animated: true)
//        self.scrollView.scrollRectToVisible(CGRect(), animated: true)
//        print("setContentOffset : \(scrollView.contentOffset)")
        btnInvite.isSelected = true
        btnFriends.isSelected = false
        btnFacebook.isSelected = false
        btnSearch.isSelected = false
    }
    
    @IBAction func btnFiendFriendsTapped(_ sender: Any) {
        imgStar.isHidden = true
        self.title = "Find Friend".localized
       scrollToPage(page: 1)
//        print("setContentOffset : \(scrollView.contentOffset)")
        scrollView.setContentOffset(CGPoint(x: windowWidth, y: scrollView.frame.minY), animated: true)
//        print("setContentOffset : \(scrollView.contentOffset)")
        btnInvite.isSelected = false
        btnFriends.isSelected = true
        btnFacebook.isSelected = false
        btnSearch.isSelected = false
    }
    
    @IBAction func btnFacebookTapped(_ sender: Any) {
        self.title = "Facebook".localized
        scrollToPage(page: 2)
//        print("setContentOffset : \(scrollView.contentOffset)")
        scrollView.setContentOffset(CGPoint(x: (windowWidth*2), y: scrollView.frame.minY), animated: true)
//        print("setContentOffset : \(scrollView.contentOffset)")
        btnInvite.isSelected = false
        btnFriends.isSelected = false
        btnFacebook.isSelected = true
        btnSearch.isSelected = false
    }
    
    @IBAction func btnSearchTapped(_ sender: Any) {
        self.title = "Search".localized
        scrollToPage(page: 3)
//        print("setContentOffset : \(scrollView.contentOffset)")
        scrollView.setContentOffset(CGPoint(x: (windowWidth*3), y: scrollView.frame.minY), animated: true)
//        print("setContentOffset : \(scrollView.contentOffset)")
        btnInvite.isSelected = false
        btnFriends.isSelected = false
        btnFacebook.isSelected = false
        btnSearch.isSelected = true
    }
}

