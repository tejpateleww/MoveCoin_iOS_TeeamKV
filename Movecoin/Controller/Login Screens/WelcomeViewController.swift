//
//  WelcomeViewController.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class WelcomeViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------

    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblTitle: LocalizLabel!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var segmentControlLanguage: UISegmentedControl!
    @IBOutlet weak var btnSignIn: ThemeButton!
    @IBOutlet weak var btnSignUp: ThemeButton!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var switchLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoTraillingConstraint: NSLayoutConstraint!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetUp()
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.animateView()
        self.setupFont()

        segmentControlLanguage.selectedSegmentIndex = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? 0 : 1
        setDataForLocalisation()
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
        lblTitle.font = UIFont.bold(ofSize: 34.0)
        lblOr.font = UIFont.bold(ofSize: 17.0)
    }
    
    func setDataForLocalisation(){
        
        // Forcefully set LTR for changing the alignment of logo and segment by constraint
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
         
         btnSignIn.setTitle("Sign in".localized, for: .normal)
         btnSignUp.setTitle("Sign Up".localized, for: .normal)
        
         lblOr.text = "OR".localized
         lblTitle.text = "Hi…Your Step Remarkable In MoveCoins".localized
         
         IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localized

         let priorityEng = UILayoutPriority(rawValue: 650)
         let priorityAR = UILayoutPriority(rawValue: 850)

         logoTraillingConstraint.priority = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? priorityAR : priorityEng
         switchLeadingConstraint.priority = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? priorityAR : priorityEng
     }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func ctrlSegmentAction(_ sender: UISegmentedControl) {
   
        if(sender.selectedSegmentIndex == 1){
            Localize.setCurrentLanguage(Languages.English.rawValue)
            lblTitle.textAlignment = .left
        }else{
            Localize.setCurrentLanguage(Languages.Arabic.rawValue)
            lblTitle.textAlignment = .right
        }
        setDataForLocalisation()
    }
    
    @IBAction func btnSignInTapped(_ sender: Any) {
        (sender as! UIButton).bounceAnimationOnCompletion {
            UIView.appearance().semanticContentAttribute = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .forceRightToLeft : .forceLeftToRight
            let controller = self.storyboard?.instantiateViewController(withIdentifier: LoginViewController.className) as! LoginViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func btnSignUpTapped(_ sender: Any) {
        (sender as! UIButton).bounceAnimationOnCompletion {
            UIView.appearance().semanticContentAttribute = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .forceRightToLeft : .forceLeftToRight
            let controller = self.storyboard?.instantiateViewController(withIdentifier: SignupViewController.className) as! SignupViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
