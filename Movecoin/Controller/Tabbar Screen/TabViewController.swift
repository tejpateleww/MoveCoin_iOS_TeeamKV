//
//  TabViewController.swift
//  Movecoin
//
//  Created by eww090 on 16/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

protocol WalletCoinsDelegate {
    func walletCoins()
}

class TabViewController: UIViewController {
  
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewTabbar: UIView!
    
    @IBOutlet var viewGradients: [UIView]!
    @IBOutlet var viewUnderLine: [UIView]!
    @IBOutlet var btnTabs: [UIButton]!
    
    @IBOutlet weak var lblStore: UILabel!
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblStatistics: UILabel!
    @IBOutlet weak var lblProfile: UILabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var arrayTabColors = [StoreColor, WalletColor, HomeColor, StatisticsColor, ProfileColor]
   
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    lazy var storeVC = mainStoryboard.instantiateViewController(withIdentifier: StoreViewController.className) as! StoreViewController
    lazy var walletVC = mainStoryboard.instantiateViewController(withIdentifier: WalletViewController.className) as! WalletViewController
    lazy var homeVC = mainStoryboard.instantiateViewController(withIdentifier: HomeViewController.className) as! HomeViewController
    lazy var statisticsVC = mainStoryboard.instantiateViewController(withIdentifier: StatisticsViewController.className) as! StatisticsViewController
    lazy var profileVC = mainStoryboard.instantiateViewController(withIdentifier: ProfileViewController.className) as! ProfileViewController
    
    lazy var mapVC = mainStoryboard.instantiateViewController(withIdentifier: MapViewController.className) as! MapViewController
    
    var viewControllers = [UIViewController]()
    
    var selectedIndex = TabBarOptions.Home.rawValue
    
    var delegateWalletCoins : WalletCoinsDelegate!
    
    var timer : Timer!
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeUI(parentView: self.viewParent)
        self.setupView()
        self.setupFont()
        self.SocketOnMethods()
        NotificationCenter.default.post(name: NotificationSetHomeVC, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setupView(){
        // Animation of view presented
        viewTabbar.alpha = 0
        viewContainer.alpha = 0
        UIView.animate(withDuration: 1) {
            self.viewContainer.alpha = 1
            self.viewTabbar.alpha = 1
        }
        
        // set home button selected, and set Gradients
        var index = 0
        for _ in viewGradients {
            self.setColorOfView(index: index)
            index += 1
        }
        viewControllers = [storeVC, walletVC, homeVC, statisticsVC, profileVC]
        self.btnTabTapped(btnTabs![selectedIndex])
    }
    
    func setupFont() {
        lblStore.font = UIFont.regular(ofSize: 12)
        lblWallet.font = UIFont.regular(ofSize: 12)
        lblHome.font = UIFont.regular(ofSize: 12)
        lblStatistics.font = UIFont.regular(ofSize: 12)
        lblProfile.font = UIFont.regular(ofSize: 12)
    }
    
    func setColorOfView(index : Int) {
        viewGradients[index].layoutIfNeeded()
        let gradient = CAGradientLayer()
        gradient.frame = viewGradients[index].bounds
        let startColor = arrayTabColors[index].withAlphaComponent(0.03)
        let endColor = arrayTabColors[index].withAlphaComponent(0.2)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        viewGradients[index].layer.insertSublayer(gradient, at: 0)
        viewUnderLine[index].backgroundColor = arrayTabColors[index]
        viewGradients[index].layoutIfNeeded()
    }
    
    func removeMapView(){
        mapVC.willMove(toParent: nil)
        mapVC.view.removeFromSuperview()
        mapVC.removeFromParent()
    }
    
    func startTimer() {
        if(timer == nil){
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (timer) in
//                print(timer)
                if  SocketIOManager.shared.socket.status == .connected {
                    if let myLocation = SingletonClass.SharedInstance.myCurrentLocation  {
                        self.emitSocket_UpdateLocation(latitute: myLocation.coordinate.latitude, long: myLocation.coordinate.longitude)
//                        print("lat \(myLocation.coordinate.latitude) , long : \(myLocation.coordinate.longitude)")
                    }
                }
            })
        }
    }
    
    //----------------------------------------------------
    // MARK: - --------- Button Action Methods ---------
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
            
            // Remove mapVC if exists
            if viewContainer.subviews.contains(mapVC.view) {
                removeMapView()
            }
            
            // Display selected VC in tab
            let vc: UIViewController = self.viewControllers[selectedIndex]
            UIView.animate(withDuration: 0.2, animations: {   
                self.view.layoutIfNeeded()
            })
            self.addChild(vc)
            vc.view.frame = viewContainer.bounds
            viewContainer.addSubview(vc.view)
            // home vc delegate assign
            if vc.isKind(of: HomeViewController.self){
                (vc as! HomeViewController).delegateFlip = self
            }
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- Custom Delegate Methods ---------
// ----------------------------------------------------

extension TabViewController : FlipToMapDelegate, FlipToHomeDelegate, WalletCoinsDelegate {
    
    func walletCoins() {
        let vc: UIViewController = self.viewControllers[TabBarOptions.Wallet.rawValue]
        if vc.isKind(of: WalletViewController.self){
            (vc as! WalletViewController).walletType = .Coins
            self.btnTabTapped(btnTabs[TabBarOptions.Wallet.rawValue])
        }
    }
    
    func flipToMap() {
        
        mapVC.delegateFlipToHome = self
        mapVC.setUpNavigationItems()
        UIView.transition(with: viewContainer, duration: 1.0, options: .transitionFlipFromLeft, animations: {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.addChild(self.mapVC)
                self.mapVC.view.frame = self.viewContainer.bounds
                self.viewContainer.addSubview(self.mapVC.view)
            })
        }, completion: nil)
    }
    
    func flipToHome() {
        
        let vc: UIViewController = self.viewControllers[selectedIndex]
        vc.viewWillAppear(true)
        
        UIView.transition(with: viewContainer, duration: 1.0, options: .transitionFlipFromLeft, animations: {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.mapVC.stopTimer()
                self.mapVC.willMove(toParent: nil)
                self.mapVC.view.removeFromSuperview()
                self.mapVC.removeFromParent()
            })
        }, completion: nil)
    }
}

