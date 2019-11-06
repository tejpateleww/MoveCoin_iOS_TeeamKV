//
//  AlertViewController.swift
//  Movecoin
//
//  Created by eww090 on 10/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    
    var alertTitle : String?
    var alertDescription : String?
    
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationBarSetUp(isHidden: false, title: "", backroundColor: .clear, hidesBackButton: true)
        self.lblTitle.text = alertTitle
        self.lblDescription.text = alertDescription
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setupFont(){
        lblTitle.font = UIFont.bold(ofSize: 22)
        lblDescription.font = UIFont.regular(ofSize: 18)
    }
    
    // ----------------------------------------------------
    // MARK: - IBAction Methods
    // ----------------------------------------------------
   
    @IBAction func btnOkTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
