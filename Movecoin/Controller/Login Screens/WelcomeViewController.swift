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

    @IBOutlet var viewParent: UIView!
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
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.animateView()
        self.setupFont()
        self.localizationSetup()
        //        localizeUI(parentView: self.viewParent)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func localizationSetup(){
        UIView.appearance().semanticContentAttribute = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .forceRightToLeft : .forceLeftToRight
        segmentControlLanguage.selectedSegmentIndex = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? 0 : 1
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.kIsOnBoardLaunched)
        
        lblOr.text = "OR".localized
        lblTitle.text = "Hi…Your Step Remarkable In MoveCoins".localized
    }
    
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
//            loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: self.view.subviews)
        }
        setDataForLocalisation()
    }

    func setDataForLocalisation(){
        UIView.appearance().semanticContentAttribute = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .forceRightToLeft : .forceLeftToRight
        btnSignIn.setTitle("Sign in".localized, for: .normal)
        btnSignUp.setTitle("Sign Up".localized, for: .normal)
       
        lblOr.text = "OR".localized
        lblTitle.text = "Hi…Your Step Remarkable In MoveCoins".localized
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
