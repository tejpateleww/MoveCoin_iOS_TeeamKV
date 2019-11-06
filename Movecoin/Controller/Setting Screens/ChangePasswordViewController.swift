//
//  ChangePasswordViewController.swift
//  Movecoin
//
//  Created by eww090 on 12/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font = UIFont.semiBold(ofSize: 21)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationBarSetUp(isHidden: false)
    }
 
}
