//
//  WelcomeViewController.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContainer.alpha = 0
        UIView.animate(withDuration: 1) {
            self.viewContainer.alpha = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
         self.statusBarSetUp(backColor: .clear, textStyle: UIBarStyle.blackTranslucent)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let nav = UINavigationController(rootViewController: self)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nav
        
        
    }
}
