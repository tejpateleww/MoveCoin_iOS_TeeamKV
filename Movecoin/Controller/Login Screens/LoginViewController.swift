//
//  LoginViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, CAAnimationDelegate {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    
    @IBOutlet weak var imgTop: UIImageView!
    
  
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
    // MARK: - IBAction Methods
    // ----------------------------------------------------
    
    @IBAction func btnSignUpTapped(_ sender: Any) {
       
        if ((self.navigationController?.hasViewController(ofKind: SignupViewController.self)) != nil) {
             self.navigationController?.popViewController(animated: true)
        }else{
            let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let signupController = loginStoryboard.instantiateViewController(withIdentifier: SignupViewController.className) as! SignupViewController
            self.navigationController?.pushViewController(signupController, animated: true)
           
        }
    }
}
