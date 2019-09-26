//
//  ForgotPasswordViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        super.viewDidAppear(true)
        navigationBarSetUp(title: "", backroundColor: .clear)
    }
}
