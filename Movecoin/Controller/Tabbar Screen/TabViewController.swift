//
//  TabViewController.swift
//  Movecoin
//
//  Created by eww090 on 16/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class TabViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewTabbar: UIView!
    

    @IBOutlet var viewGradients: [UIView]!
    @IBOutlet var viewUnderLine: [UIView]!
    @IBOutlet var btnTabs: [UIButton]!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    
    var arrayTabColors = [StoreColor, WalletColor, HomeColor, StatisticsColor, ProfileColor]
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    lazy var storeVC = mainStoryboard.instantiateViewController(withIdentifier: StoreViewController.className) as! StoreViewController
    lazy var walletVC = mainStoryboard.instantiateViewController(withIdentifier: WalletViewController.className) as! WalletViewController
    lazy var homeVC = mainStoryboard.instantiateViewController(withIdentifier: HomeViewController.className) as! HomeViewController
    lazy var statisticsVC = mainStoryboard.instantiateViewController(withIdentifier: StatisticsViewController.className) as! StatisticsViewController
    lazy var profileVC = mainStoryboard.instantiateViewController(withIdentifier: ProfileViewController.className) as! ProfileViewController
    
    var viewControllers = [UIViewController]()
    
    var selectedIndex = 2
    
    //----------------------------------------------------
    // MARK: - Button Action Methods
    // ----------------------------------------------------
    
    @IBAction func btnTabTapped(_ sender: Any) {
        
        let button = sender as! UIButton
        
        let previousIndex = selectedIndex
        selectedIndex = button.tag
        
        // Set button background color
        button.isSelected = !button.isSelected
        viewGradients[previousIndex].backgroundColor = .clear
        viewGradients[selectedIndex].backgroundColor = arrayTabColors[selectedIndex]
        
        if self.viewControllers.count > 0 {
            //Remove previous VC from tab
            let previousVC: UIViewController = self.viewControllers[previousIndex]
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
            
            // Display selected VC in tab
            let vc: UIViewController = self.viewControllers[selectedIndex]
            UIView.animate(withDuration: 0.2, animations: {    //        [self.imgViews[previousIndex]setImage:[UIImage imageNamed:strUnSelectedImages]];
                self.view.layoutIfNeeded()
            })
            self.addChild(vc)
            vc.view.frame = viewContainer.bounds
            viewContainer.addSubview(vc.view)
        }
        
        
//        self.view.bringSubview(toFront: _tabbarView)
       
    }
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTabbar.alpha = 0
        viewContainer.alpha = 0
        UIView.animate(withDuration: 1) {
            self.viewContainer.alpha = 1
            self.viewTabbar.alpha = 1
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
//        let nav = UINavigationController(rootViewController: self)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = nav
        
        var index = 0
        for _ in viewGradients {
            self.setColorOfView(index: index)
            index += 1
        }
        viewControllers = [storeVC, walletVC, homeVC, statisticsVC, profileVC]
        self.btnTabTapped(btnTabs![selectedIndex])
    }
    
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setColorOfView(index : Int) {
        let gradient = CAGradientLayer()
        gradient.frame = viewGradients[index].bounds
        let startColor = arrayTabColors[index].withAlphaComponent(0.07)
        let endColor = arrayTabColors[index].withAlphaComponent(0.2)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        viewGradients[index].layer.insertSublayer(gradient, at: 0)
        viewUnderLine[index].backgroundColor = arrayTabColors[index]
    }
}
