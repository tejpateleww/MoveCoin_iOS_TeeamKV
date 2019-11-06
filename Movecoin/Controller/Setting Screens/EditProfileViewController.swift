//
//  EditProfileViewController.swift
//  Movecoin
//
//  Created by eww090 on 22/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(isHidden: false, title: "Edit Profile", hidesBackButton: false)
    }
}
