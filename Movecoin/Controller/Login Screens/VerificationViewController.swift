//
//  VerificationViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var firstPinView: VKPinCodeView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSendAgian: UIButton!
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpPinView()
        self.setupFont()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationBarSetUp(isHidden: false, title: "Verification Code", backroundColor: .clear, hidesBackButton: false)
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setUpPinView(){
        
        let underline = VKEntryViewStyle.underline(
            font: UIFont.regular(ofSize: 20),
            textColor: .white,
            errorTextColor: .red,
            lineWidth: 2,
            lineColor: .white,
            selectedLineColor: .white,
            errorLineColor: .red)
        
        firstPinView.setStyle(underline)
        firstPinView.validator = validator(_:)
    }
    
    func setupFont(){
        lblDescription.font = UIFont.regular(ofSize: 14)
        btnSendAgian.titleLabel?.font = UIFont.regular(ofSize: 17)
    }
    
    private func validator(_ code: String) -> Bool {
        
        return !code.trimmingCharacters(in: CharacterSet.decimalDigits.inverted).isEmpty
    }

}
