//
//  SignupViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // ----------------------------------------------------
    // MARK: - IBActions Methods
    // ----------------------------------------------------
    
    @IBAction func btnSignInTapped(_ sender: Any) {
      
        if ((self.navigationController?.hasViewController(ofKind: LoginViewController.self)) != nil) {
            self.navigationController?.popViewController(animated: true)
        }else{
            let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let loginController = loginStoryboard.instantiateViewController(withIdentifier: LoginViewController.className) as! LoginViewController
            self.navigationController?.pushViewController(loginController, animated: true)
            
        }
    }
}
