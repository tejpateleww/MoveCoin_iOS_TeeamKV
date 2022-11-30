//
//  AlertViewController.swift
//  Movecoin
//
//  Created by eww090 on 10/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

public protocol AlertDelegate: class {
    func okHandler()
}

class AlertViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var lblTitle: LocalizLabel!
    @IBOutlet weak var lblDescription: LocalizLabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var alertTitle : String?
    var alertDescription : String?
    var delegate: AlertDelegate?
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarSetUp(hidesBackButton: true)
        self.setupFont()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.lblTitle.text = alertTitle
        self.lblDescription.text = alertDescription
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setupFont(){
        lblTitle.font = UIFont.regular(ofSize: 22)
        lblDescription.font = UIFont.regular(ofSize: 18)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
   
    @IBAction func btnOkTapped(_ sender: Any) {
        self.dismiss(animated: true, completion:nil)
        self.delegate?.okHandler()
    }
}
