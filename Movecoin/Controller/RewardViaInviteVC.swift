//
//  RewardViaInviteVC.swift
//  Movecoins
//
//  Created by Hiral's iMac on 24/11/20.
//  Copyright © 2020 eww090. All rights reserved.
//

import UIKit

class RewardViaInviteVC: UIViewController {

    @IBOutlet weak var lblMsg: LocalizLabel!{
        didSet{
            self.lblMsg.font = FontBook.Bold.of(size: 21)
            self.lblMsg.text = "Your reward in process".localized
        }
    }
    @IBOutlet weak var btnOk: UIButton!{
        didSet{
            self.btnOk.titleLabel?.font = FontBook.SemiBold.of(size: 17)
            self.btnOk.layer.cornerRadius = btnOk.frame.height / 2
            self.btnOk.layer.borderWidth = 0.5
            btnOk.layer.borderColor = UIColor(red: 40/255, green: 165/255, blue: 198/255, alpha: 1.0).cgColor
        }
    }
    
    @IBOutlet weak var viewPop: UIView!{ didSet{ viewPop.layer.cornerRadius = 15}}
    
    var closureOKTappped : (() -> ()) = {  }
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func btnOkTap(_ sender: Any) {
        self.dismiss(animated: true) {
            self.closureOKTappped()
        }
    }
    
  

}
