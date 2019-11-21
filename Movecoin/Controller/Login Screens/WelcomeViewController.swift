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
    // MARK: - IBOutlets 
    // ----------------------------------------------------

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var segmentControlLanguage: UISegmentedControl!
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animateView()
        self.setupFont()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationBarSetUp(isHidden: true)
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
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
    // MARK: - IBAction Methods
    // ----------------------------------------------------
    
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
