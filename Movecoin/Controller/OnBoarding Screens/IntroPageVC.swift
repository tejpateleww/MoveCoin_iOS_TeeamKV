//
//  IntroPageVC.swift
//  Movecoins
//
//  Created by eww090 on 29/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import AVFoundation

class IntroPageVC: UIViewController {

        // ----------------------------------------------------
        // MARK: - --------- IBOutlets ---------
        // ----------------------------------------------------
        
        
        // ----------------------------------------------------
        // MARK: - --------- Variables ---------
        // ----------------------------------------------------
        
        var image : String!
    
        lazy var userPermission = UserPermission()
        
        // ----------------------------------------------------
        // MARK: - --------- ViewController Lifecycle Methods ---------
        // ----------------------------------------------------
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.initialSetup()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
        }
        
        // ----------------------------------------------------
        // MARK: - --------- Custom Methods ---------
        // ----------------------------------------------------
        
        func initialSetup(){
            let imageview = UIImageView(frame: self.view.frame)
            imageview.image = UIImage(named: image)
            imageview.contentMode = .scaleAspectFill
            self.view.addSubview(imageview)
            
            // For Request Permission
            
            if image == "intro-1" {
                userPermission.permissions = [.camera, .locationPermission, .motion, .healthKit]
                for type in userPermission.permissions {
                    userPermission.requestForPermission(type: type)
                }
            }
        }

}
