//
//  TransferMoveCoinsViewController.swift
//  Movecoin
//
//  Created by eww090 on 22/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import FirebaseAnalytics
class TransferMoveCoinsViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var btnTransferMoney: ThemeButton!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
//    var receiverData : FriendsData?
    var receiverName : String?
    var receiverID : String?
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.setupFont()
        txtAmount.delegate = self
        if let name = receiverName {
            let to = "To ".localized
            let name = "\(to) \( name)"
            lblName.text = name //"To ".localized + name
        }
        
        Analytics.logEvent("TransferMoveCoinsScreen", parameters: nil)
        self.title = "Sending Coins".localized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(title: "Sending Coins")
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setupFont(){
        lbl1.font = UIFont.regular(ofSize: 24)
        lblName.font = UIFont.regular(ofSize: 24)
        txtAmount.font = UIFont.regular(ofSize: 40)
        txtMessage.font = UIFont.regular(ofSize: 19)
        btnTransferMoney.titleLabel?.font = UIFont.regular(ofSize: 24)
        
        // For Localization
        txtAmount.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        txtAmount.placeholder = txtAmount.placeholder?.localized
        txtMessage.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        txtMessage.placeholder = txtMessage.placeholder?.localized
        txtMessage.placeHolderColor = TransparentColor
        txtAmount.placeHolderColor = TransparentColor
    }
    
    // ----------------------------------------------------
    //MARK:- --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnSendTapped(_ sender: Any) {
        let amount = Int(txtAmount.text?.replacingOccurrences(of: ",", with: "") ?? "0") ?? 0
        if amount == 0 {
            UtilityClass.showAlert(Message: "Please enter amount".localized)
           
        } else if (amount > 0){
            let requestModel = TransferCoinsModel()
            requestModel.SenderID = SingletonClass.SharedInstance.userData?.iD ?? ""
            requestModel.ReceiverID = receiverID ?? ""
            requestModel.Coins = "\(amount)"
            requestModel.Message = txtMessage.text ?? ""
            webserviceForTransferCoins(dic: requestModel)
           
        } else{
            UtilityClass.showAlert(Message: "Amount should be greater than zero".localized)
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- Textfield Delegate Methods ---------
// ----------------------------------------------------

extension TransferMoveCoinsViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtAmount.placeholder = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

         // Uses the number format corresponding to your Locale
         let formatter = NumberFormatter()
         formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")

         formatter.maximumFractionDigits = 0


        // Uses the grouping separator corresponding to your Locale
        // e.g. "," in the US, a space in France, and so on
        if let groupingSeparator = formatter.groupingSeparator {

            if string == groupingSeparator {
                return true
            }


            if let textWithoutGroupingSeparator = textField.text?.replacingOccurrences(of: groupingSeparator, with: "") {
                var totalTextWithoutGroupingSeparators = textWithoutGroupingSeparator + string
                if string.isEmpty { // pressed Backspace key
                    totalTextWithoutGroupingSeparators.removeLast()
                }
                if let numberWithoutGroupingSeparator = formatter.number(from: totalTextWithoutGroupingSeparators),
                    let formattedText = formatter.string(from: numberWithoutGroupingSeparator) {

                    textField.text = formattedText
                    return false
                }
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtAmount.text!.isEmpty {
            txtAmount.placeholder = "Amount".localized
        }
    }
}


// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension TransferMoveCoinsViewController {
    
    func webserviceForTransferCoins(dic : TransferCoinsModel){
       
        UtilityClass.showHUD()
        
        FriendsWebserviceSubclass.transferCoins(transferCoinModel: dic){ (json, status, res) in
            UtilityClass.hideHUD()
            
            if status {
                self.view.endEditing(true)
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
                UtilityClass.showAlertWithCompletion(title: "", Message: msg, ButtonTitle: "OK".localized, Completion: {
                    self.navigationController?.popViewController(animated: true)
                })
                
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
