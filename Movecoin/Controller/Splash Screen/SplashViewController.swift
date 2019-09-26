//
//  SplashViewController.swift
//  Movecoin
//
//  Created by eww090 on 17/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit



class SplashViewController: UIViewController , CAAnimationDelegate {
    
    // ----------------------------------------------------
    //MARK:- --------- IBOutlets ---------
    // ----------------------------------------------------
   
    @IBOutlet weak var viewContainer: LKAWaveCircleProgressBar!
    @IBOutlet weak var imgM: UIImageView!
    @IBOutlet weak var imgCircle: UIImageView!
    @IBOutlet weak var imgPlainCircle: UIImageView!
    
   
    var mask: CALayer?
    var imageView: UIImageView?
    
    // ----------------------------------------------------
    //MARK:- --------- Lifecycle Methods ---------
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // logo annimation of wave
        viewContainer.setProgress(0, animated: true)
        viewContainer.startWaveRollingAnimation()
        viewContainer.progressAnimationDuration = 7
        viewContainer.setProgress(101, animated: true)
        viewContainer.progressTintColor = UIColor.white.withAlphaComponent(0.3)
        viewContainer.borderColor = .clear


        Timer.scheduledTimer(withTimeInterval: 7, repeats: false) { (timer) in
            self.viewContainer.stopWaveRollingAnimation()
           self.moveToViewController()

        }
        
        
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//
//        var frame = self.imgM.frame
//        frame.origin.x = self.view.center.x - frame.width/2
//        self.imgM.frame = frame
//
////        self.imgCircle.transform = CGAffineTransform(rotationAngle: .pi)
//        UIView.animate(withDuration: 5, animations: {
//            self.imgCircle.alpha = 1
//            self.imgPlainCircle.alpha = 1
//        }, completion: nil)
//
//        UIView.animate(withDuration: 1, animations: {
//
//            self.imgM.center = self.view.center
//        }, completion: { (finish) in
//
//            self.imgM.transform = CGAffineTransform.identity.scaledBy(x: 0.05, y: 0.05)
//            UIView.animate(withDuration: 2.5,
//                           delay: 0,
//                           usingSpringWithDamping: 0.2,
//                           initialSpringVelocity: 2.0,
//                           options: .allowUserInteraction,
//                           animations: { [weak self] in
//                            self?.imgM.transform = .identity
//                            self?.imgCircle.transform = CGAffineTransform(rotationAngle: .pi)
//                },completion: { (finish) in
//
//
//                    UIView.animate(withDuration: 0.2, animations: {
//
//                        self.imgM.transform = CGAffineTransform.identity.scaledBy(x: 3, y: 3)
//                        self.imgPlainCircle.transform = CGAffineTransform.identity.scaledBy(x: 3, y: 3)
//                        self.imgCircle.transform = CGAffineTransform.identity.scaledBy(x: 3, y: 3)
//
//                        self.imgCircle.alpha = 0
//                        self.imgPlainCircle.alpha = 0
//                        self.imgM.alpha = 0
//
//                    }, completion: { (finish) in
//
//                        self.moveToViewController()
//                    })
//            })
//        } )
//    }
//  
    func moveToViewController(){

        if UserDefaults.standard.value(forKey: kIsLogedIn) != nil {
           
            if UserDefaults.standard.value(forKey: kIsLogedIn) as! Bool {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeVC = storyboard.instantiateViewController(withIdentifier: TabViewController.className) as! TabViewController
                 self.present(homeVC, animated: false, completion: nil)

            }else {
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let welcomeVC = storyboard.instantiateViewController(withIdentifier: WelcomeViewController.className) as! WelcomeViewController
                self.navigationController?.pushViewController(welcomeVC, animated: false)
            }
        }else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let homeVC = storyboard.instantiateViewController(withIdentifier: TabViewController.className) as! TabViewController
//            self.present(homeVC, animated: false, completion: nil)

            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let welcomeVC = storyboard.instantiateViewController(withIdentifier: WelcomeViewController.className) as! WelcomeViewController
            self.navigationController?.pushViewController(welcomeVC, animated: false)
        }
    }
}
