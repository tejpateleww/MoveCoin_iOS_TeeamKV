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
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblOr: UILabel!
    
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationBarSetUp(isHidden: true)
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setupFont(){
        lblTitle.font = UIFont.regular(ofSize: 20)
        lblAccount.font = UIFont.light(ofSize: 15)
        lblOr.font = UIFont.regular(ofSize: 15)
        btnSignUp.titleLabel?.font = UIFont.light(ofSize: 20)
        btnForgotPassword.titleLabel?.font = UIFont.bold(ofSize: 15)
    }
    
    // ----------------------------------------------------
    // MARK: - IBAction Methods
    // ----------------------------------------------------
    
    @IBAction func btnSignUpTapped(_ sender: Any) {
        if ((self.navigationController?.hasViewController(ofKind: SignupViewController.self)) != nil) {
            self.popViewControllerWithFlipAnimation()
        }else{
            let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let signupController = loginStoryboard.instantiateViewController(withIdentifier: SignupViewController.className) as! SignupViewController
            self.pushViewControllerWithFlipAnimation(viewController: signupController)
        }
    }
    @IBAction func btnSignInTapped(_ sender: Any) {
        (sender as! UIButton).bounceAnimationOnCompletion {
            UserDefaults.standard.set(true, forKey: UserDefaultKeys.IsLogin)
            AppDelegateShared.GoToHome()
        }
    }
}
