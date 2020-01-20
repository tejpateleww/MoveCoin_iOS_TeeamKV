//
//  FacebookViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class FacebookViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblDescription: UILabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        lblDescription.font = UIFont.regular(ofSize: 15)
       
//        let graphRequest = FBSDKGraphRequest(graphPath: "/100045623749915/friends", parameters: params)
//        let connection = FBSDKGraphRequestConnection()
    }
    
    // ----------------------------------------------------
    //MARK:- --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnConnectFacebookTapped(_ sender: Any) {
        if SingletonClass.SharedInstance.userData?.socialID.isBlank ?? true {
            
        }
    }
}
