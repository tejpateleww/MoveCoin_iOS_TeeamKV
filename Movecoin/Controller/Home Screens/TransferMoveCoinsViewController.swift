//
//  TransferMoveCoinsViewController.swift
//  Movecoin
//
//  Created by eww090 on 22/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class TransferMoveCoinsViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
        txtAmount.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(title: "Sending MoveCoins")
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setupFont(){
        lbl1.font = UIFont.semiBold(ofSize: 24)
        lblName.font = UIFont.semiBold(ofSize: 24)
        txtAmount.font = UIFont.bold(ofSize: 40)
        txtMessage.font = UIFont.regular(ofSize: 19)
    }
}

extension TransferMoveCoinsViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtAmount.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtAmount.text!.isEmpty {
            txtAmount.placeholder = "Amount"
        }
    }
}
