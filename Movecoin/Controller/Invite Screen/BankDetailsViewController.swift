//
//  BankDetailsViewController.swift
//  Movecoins
//
//  Created by Apple on 27/11/20.
//  Copyright © 2020 eww090. All rights reserved.
//

import UIKit

class BankDetailsViewController: UIViewController {
    @IBOutlet weak var txtAccountOwner: TextFieldFont!
    
    @IBOutlet weak var txtIbanBank: TextFieldFont!
    @IBOutlet weak var txtContactNumber: TextFieldFont!
    @IBOutlet weak var btnSubmit: ThemeButton!
    @IBOutlet weak var txtNameOfTheBank: TextFieldFont!
    
    var strClaimedSAR = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bank Information".localized
        
        
        txtIbanBank.placeholder = "IBAN Bank".localized
//        txtContactNumber.placeholder = "".localized
        btnSubmit.setTitle("Submit".localized, for: .normal)
        txtNameOfTheBank.placeholder = "Name of the Bank".localized
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSubmit(sender : UIButton)
    {
        webserviceCallForClaimReward()
    }
    
    func webserviceCallForClaimReward()
    {
        let redeemClaimData = RedeemClaim()
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
        redeemClaimData.account_owner = txtAccountOwner.text ?? ""
        redeemClaimData.iban_bank = txtIbanBank.text ?? ""
        redeemClaimData.sar = strClaimedSAR
        redeemClaimData.user_id = id
        redeemClaimData.name_of_bank = txtNameOfTheBank.text ?? ""
        UtilityClass.showHUD()
        UserWebserviceSubclass.rewardClaim(redeemClaim: redeemClaimData) { (json, status, res) in
            UtilityClass.hideHUD()
            if(status)
            {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let popReward = mainStoryboard.instantiateViewController(withIdentifier: RewardViaInviteVC.className) as! RewardViaInviteVC
                popReward.modalPresentationStyle = .overCurrentContext
                popReward.modalTransitionStyle = .coverVertical
                popReward.closureOKTappped = {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                self.present(popReward, animated: true, completion: nil)
            }
            else
            {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
