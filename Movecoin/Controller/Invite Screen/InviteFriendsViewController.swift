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
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var lblTitle: LocalizLabel!
    @IBOutlet weak var lblDescription: LocalizLabel!
    @IBOutlet weak var lblCode: LocalizLabel!
    @IBOutlet weak var lblReferral: UILabel!
    @IBOutlet weak var viewReferralCode: TransparentView!
    @IBOutlet weak var viewBoxAnimation: UIView!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var animationView = AnimationView(name: "happy-birthday")
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
       
        viewReferralCode.addDashedBorder()
        lblReferral.text = SingletonClass.SharedInstance.userData?.referralCode ?? ""
//        self.animate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("ViewdidAppear")
//        self.animate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
        self.animate()
//        self.view.layoutIfNeeded()
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setupFont(){
        lblTitle.font = UIFont.semiBold(ofSize: 25)
        lblDescription.font = UIFont.regular(ofSize: 15)
        lblCode.font = UIFont.regular(ofSize: 20)
        lblReferral.font = UIFont.semiBold(ofSize: 18)
    }
    
    func animate() {
        print("Animate")
        animationView.frame = CGRect(x: 0, y: 0, width: viewBoxAnimation.frame.width, height: viewBoxAnimation.frame.height)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 0.5
        if !viewBoxAnimation.subviews.contains(animationView){
            viewBoxAnimation.addSubview(animationView)
        }
        
//        animationView.play { (success) in
//            self.animate()
//        }
        
        animationView.play()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnInviteFriendsTapped(_ sender: Any) {
        
        //        if let reviewURL = URL(string: "itms-apps://itunes.apple.com/us/app/apple-store/1483785971?mt=8"), UIApplication.shared.canOpenURL(reviewURL) {
        //             if #available(iOS 10.0, *) {
        //               UIApplication.shared.open(reviewURL, options: [:]
        //        , completionHandler: nil)
        //             } else {
        //               UIApplication.shared.openURL(reviewURL)
        //             }
        //        }
        
        let text = "Check out this app ".localized + kAppName.localized + ", referral code - ".localized + (lblReferral.text ?? "")
        let image = UIImage(named: "AppIcon")
        let url = URL(string:"itms-apps://itunes.apple.com/app/apple-store/id1483785971?mt=8")
        
        let vc = UIActivityViewController(activityItems: [text, image ?? UIImage(), url!], applicationActivities: [])
        present(vc, animated: true)
    }
}
