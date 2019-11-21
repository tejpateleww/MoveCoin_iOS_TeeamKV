//
//  ViewController.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import CoreMotion

protocol FlipToMapDelegate {
    func flipToMap()
}

class HomeViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet var lblTitles: [UILabel]!
    @IBOutlet weak var lblTotalSteps: UILabel!
    @IBOutlet weak var lblCoins: UILabel!
    @IBOutlet weak var lblInviteFriends: UILabel!
    @IBOutlet weak var lblFriends: UILabel!
    
    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTodaysStepCount: UILabel!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    
    var delegateFlip : FlipToMapDelegate!
    
    lazy var pedoMeter = CMPedometer()
    lazy var motionManager = CMMotionManager()
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
        imgLogo.image = UIImage.gifImageWithName("Logo")
        getUserData()
        
        
        checkPermissionForMotionSensor()
        getTodaysStepCounts()
    }
    
    func checkPermissionForMotionSensor() {
        
        switch CMPedometer.authorizationStatus() {
        case .authorized :
            print(" Authotized")
            self.startCountingSteps()

        case .denied, .restricted :
            print("Not Authotized")

        case  .notDetermined:
            print("unknown")

        @unknown default:
            fatalError()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationBarSetUp(hidesBackButton: true)
        setUpNavigationItems()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.parent?.navigationItem.leftBarButtonItems?.removeAll()
        self.parent?.navigationItem.setRightBarButton(nil, animated: true)
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setupFont(){
        for lbl in lblTitles{
            lbl.font = UIFont.regular(ofSize: 17)
        }
        lblCoins.font = UIFont.semiBold(ofSize: 24)
        lblFriends.font = UIFont.semiBold(ofSize: 24)
        lblTotalSteps.font = UIFont.semiBold(ofSize: 24)
        lblInviteFriends.font = UIFont.semiBold(ofSize: 24)
        
        lblDescription.font = UIFont.semiBold(ofSize: 25)
        lblMember.font = UIFont.light(ofSize: 13)
    }
    
    func setUpNavigationItems(){
        _ = UIBarButtonItem(image: UIImage(named: "upgrad-icon"), style: .plain, target: self, action: #selector(btnUpgradeTapped))
//        self.parent?.navigationItem.setLeftBarButtonItems([leftBarButton], animated: true)
       
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "flip-icon"), style: .plain, target: self, action: #selector(btnFlipTapped))
        self.parent?.navigationItem.setRightBarButtonItems([rightBarButton], animated: true)
    }
    
    @objc func btnUpgradeTapped(){

    }
    
    @objc func btnFlipTapped(){
        self.delegateFlip.flipToMap()
    }
    
    func getTodaysStepCounts() {
        pedoMeter.queryPedometerData(from: Date().midnight, to: Date()) { (data, error) in
            print("queryPedometerData : ", data ?? 0)
            guard let activityData = data else {
                return
            }
            DispatchQueue.main.async {
                self.lblTodaysStepCount.text = activityData.numberOfSteps.stringValue
            }
            SingletonClass.SharedInstance.todaysStepCount = activityData.numberOfSteps
        }
    }
    
    func startCountingSteps(){
        if CMPedometer.isStepCountingAvailable(){
            pedoMeter.startUpdates(from: Date()) { (data, error) in
                print(data ?? 0)
                guard let activityData = data else {
                    return
                }
                DispatchQueue.main.async {
                    if let counts = SingletonClass.SharedInstance.todaysStepCount {
                        let total = counts.intValue + activityData.numberOfSteps.intValue
                        self.lblTodaysStepCount.text = "\(total)"
                        print("Total:\(total)")
                    }else {
                        self.lblTodaysStepCount.text = activityData.numberOfSteps.stringValue
                    }
                }
            }
        }
    }
    
    // ----------------------------------------------------
    // MARK: - IBAction Methods
    // ----------------------------------------------------
    
    @IBAction func btnCoinsTapped(_ sender: Any) {
        let parentVC = self.parent as! TabViewController
        parentVC.delegateWalletCoins = parentVC
        parentVC.delegateWalletCoins.walletCoins()
//        parentVC.btnTabTapped(parentVC.btnTabs[TabBarOptions.Wallet.rawValue])
    }
}

