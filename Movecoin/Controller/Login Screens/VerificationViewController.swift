//
//  VerificationViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController {
    
    @IBOutlet weak var firstPinView: VKPinCodeView!
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpPinView()
     
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationBarSetUp(title: "Verification Code", backroundColor: .clear)
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setUpPinView(){
        
        let underline = VKEntryViewStyle.underline(
            font: UIFont(name: "Nunito-Regular", size: 20)!,
            textColor: .white,
            errorTextColor: .red,
            lineWidth: 2,
            lineColor: .white,
            selectedLineColor: .white,
            errorLineColor: .red)
        
        firstPinView.setStyle(underline)
        firstPinView.validator = validator(_:)
    }
    
    private func validator(_ code: String) -> Bool {
        
        return !code.trimmingCharacters(in: CharacterSet.decimalDigits.inverted).isEmpty
    }

}
