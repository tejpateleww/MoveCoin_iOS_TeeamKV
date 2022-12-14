//
//  ForgotPasswordViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var lblTitle: LocalizLabel!
    @IBOutlet weak var txtEmail: TextFieldFont!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetUp()
        lblTitle.font = UIFont.regular(ofSize: 21)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func validate() {
        do {
            let email = try txtEmail.validatedText(validationType: ValidatorType.email)
            let requestModel = ForgotPassword()
            requestModel.Email = email
            webserviceCallForForgotPassword(requestDic: requestModel)
        } catch(let error) {
            UtilityClass.showAlert(Message: (error as! ValidationError).message.localized)
        }
    }
    
    // ----------------------------------------------------
    //MARK:- --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnSendAction(_ sender: Any) {
        validate()
    }
}

// ----------------------------------------------------
// MARK: - --------- Webservice Methods ---------
// ----------------------------------------------------

extension ForgotPasswordViewController {
    
    func webserviceCallForForgotPassword(requestDic: ForgotPassword){
        
        UtilityClass.showHUD()
        
        UserWebserviceSubclass.forgotPassword(ForgotPasswordModel: requestDic) { (json, status, res) in
            
            UtilityClass.hideHUD()
            print(json)
            
            if status{
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
                UtilityClass.showAlertWithCompletion(title: "", Message: msg, ButtonTitle: "OK".localized, Completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
            else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
