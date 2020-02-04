//
//  WelcomeViewController.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var segmentControlLanguage: UISegmentedControl!
    @IBOutlet weak var btnSignIn: ThemeButton!
    @IBOutlet weak var btnSignUp: ThemeButton!
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetUp()
        self.animateView()
        self.setupFont()
        segmentControlLanguage.selectedSegmentIndex = 1
        if let lang = UserDefaults.standard.string(forKey: "i18n_language"), lang == secondLanguage {
            segmentControlLanguage.selectedSegmentIndex = 0
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }else {
            segmentControlLanguage.selectedSegmentIndex = 1
        }
       
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.kIsOnBoardLaunched)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func animateView(){
        viewContainer.alpha = 0
        UIView.animate(withDuration: 1) {
            self.viewContainer.alpha = 1
        }
    }
    
    func setupFont(){
        lblTitle.font = UIFont.bold(ofSize: 38.0)
        lblOr.font = UIFont.bold(ofSize: 17.0)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func ctrlSegmentAction(_ sender: UISegmentedControl) {
   
        if(sender.selectedSegmentIndex == 1){
            UserDefaults.standard.set("en", forKey: "i18n_language")
            UserDefaults.standard.synchronize()
//            DispatchQueue.main.async {
//                UIView.appearance().semanticContentAttribute = .forceLeftToRight
//                UITextField.appearance().semanticContentAttribute = .forceLeftToRight
//            }
        }else{
            UserDefaults.standard.set(secondLanguage, forKey: "i18n_language")
            UserDefaults.standard.synchronize()
//            DispatchQueue.main.async {
//                UIView.appearance().semanticContentAttribute = .forceRightToLeft
//                UITextField.appearance().semanticContentAttribute = .forceRightToLeft
//            }
//            loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: self.view.subviews)
        }
        setDataForLocalisation()
    }

    func setDataForLocalisation(){
        
        btnSignIn.setTitle("Sign in".localized, for: .normal)
        btnSignUp.setTitle("Sign Up".localized, for: .normal)
       
        lblOr.text = "OR".localized
        lblTitle.text = "Lorem Ipsum Simply Dummy".localized
//        txtEmail.placeholder = "Mobile/Email".localized
//        txtPassword.placeholder = "Password".localized
//        lblOrTitle.text = "OR".localized
//        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localized

    }
    
    @IBAction func btnSignInTapped(_ sender: Any) {
        (sender as! UIButton).bounceAnimationOnCompletion {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: LoginViewController.className) as! LoginViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func btnSignUpTapped(_ sender: Any) {
        (sender as! UIButton).bounceAnimationOnCompletion {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: SignupViewController.className) as! SignupViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
