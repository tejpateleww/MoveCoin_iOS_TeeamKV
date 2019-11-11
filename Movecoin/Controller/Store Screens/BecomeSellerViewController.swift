//
//  BecomeSellerViewController.swift
//  Movecoin
//
//  Created by eww090 on 12/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class BecomeSellerViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font = UIFont.regular(ofSize: 21)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationBarSetUp(isHidden: false)
    }
    
    // ----------------------------------------------------
    // MARK: - IBAction Methods
    // ----------------------------------------------------
    
    @IBAction func btnRegisterTapped(_ sender: Any) {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyborad.instantiateViewController(withIdentifier: AlertViewController.className) as! AlertViewController
        destination.alertTitle = "Thank You"
        destination.alertDescription = "Thank you for registering with us, Please check your email and activate your portal and fill additional information so MoveCoins can review your application and contact you."
        
        destination.modalPresentationStyle = .overCurrentContext
        self.present(destination, animated: true, completion: nil)
//        add(destination, frame: self.view.frame)
    }
}
