//
//  InviteFriendsViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import Lottie

class InviteFriendsViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblReferral: UILabel!
    @IBOutlet weak var viewReferralCode: TransparentView!
    @IBOutlet weak var viewBoxAnimation: UIView!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    
    var animationView = AnimationView(name: "happy-birthday")
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
        viewReferralCode.addDashedBorder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.animate()
    }
    
    // ----------------------------------------------------
    // MARK: - IBAction Methods
    // ----------------------------------------------------
    
    @IBAction func btnInviteFriendsTapped(_ sender: Any) {
        let text = lblReferral.text
        let image = UIImage(named: "Logo")
        let url = NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
        
        let vc = UIActivityViewController(activityItems: [text!, image!, url!], applicationActivities: [])
        present(vc, animated: true)
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setupFont(){
        lblTitle.font = UIFont.semiBold(ofSize: 25)
        lblDescription.font = UIFont.regular(ofSize: 15)
        lblCode.font = UIFont.regular(ofSize: 20)
        lblReferral.font = UIFont.semiBold(ofSize: 18)
    }
    
    func animate() {
        
        animationView.frame = CGRect(x: 0, y: 0, width: viewBoxAnimation.frame.width, height: viewBoxAnimation.frame.height)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 0.5
        if !viewBoxAnimation.subviews.contains(animationView){
            viewBoxAnimation.addSubview(animationView)
        }
        
        animationView.play { (success)
            in
            
            self.animate()
        }
    }
}
