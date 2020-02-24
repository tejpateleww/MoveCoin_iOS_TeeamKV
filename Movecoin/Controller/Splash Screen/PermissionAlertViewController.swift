//
//  PermissionAlertViewController.swift
//  Movecoins
//
//  Created by eww090 on 20/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class PermissionAlertViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var lblTitle: LocalizLabel!
    @IBOutlet weak var lblDescription: LocalizLabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var stepsPermissionType : StepsPermission!
    
    // ----------------------------------------------------
    // MARK: - --------- ViewController Lifecycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarSetUp(hidesBackButton: true)
        //        localizeUI(parentView: self.viewParent)
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
  
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func initialSetup() {
        lblTitle.font = UIFont.bold(ofSize: 22)
        lblDescription.font = UIFont.regular(ofSize: 18)
        
        switch stepsPermissionType {
        case .HealthKit:
            lblDescription.text = "Oops, I can't see your HealthKit data. Tap Fix Settings to turn on switches."
        case .MotionAndFitness:
            lblDescription.text = "To start please let me see the total steps your phone detects."
        default:
            return
        }
    }
    
    // ----------------------------------------------------
    //MARK:- --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnAllowTapped(_ sender: Any) {
        
        switch stepsPermissionType {
        case .HealthKit:
            guard let healthKitUrl = URL(string: "x-apple-health://") else {
                return
            }
            
            if UIApplication.shared.canOpenURL(healthKitUrl) {
                UIApplication.shared.open(healthKitUrl, completionHandler: { (success) in
                    print("HealthKit opened: \(success)") // Prints true
                })
            }
        case .MotionAndFitness :
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        case .none:
            return
        }
    }
}
