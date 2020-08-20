//
//  ChangePasswordViewController.swift
//  Movecoin
//
//  Created by eww090 on 12/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    // ----------------------------------------------------
    //MARK:- --------- IBOutlets  ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtCurrentPassword: TextFieldFont!
    @IBOutlet weak var txtNewPassword: TextFieldFont!
    @IBOutlet weak var txtConfirmPassword: TextFieldFont!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font = UIFont.semiBold(ofSize: 21)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationBarSetUp()
    }
    
    // ----------------------------------------------------
    //MARK:- --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func ValidationForChangePwd(model: ChangePassword) -> (Bool,String)
    {
        if(model.OldPassword.isBlank)
        {
            return (false,"Please enter current password".localized)
        }
//        else if(txtCurrentPassword.text!.count < 6)
//        {
//            return (false,"Old Password length should be  minimum 6 character")
//        }
        else if(model.NewPassword.isBlank)
        {
            return (false,"Please enter new password".localized)
        }
        else if(txtNewPassword.text!.count < 6)
        {
            return (false,"New Password length should be  minimum 6 character".localized)
        }
        else if(txtConfirmPassword.text!.isBlank)
        {
            return (false,"Please enter confirm password".localized)
        }
//        else if(txtConfirmPassword.text!.count < 6)
//        {
//            return (false,"Confirm Password length should be  minimum 6 character")
//        }
        else if(txtNewPassword.text! != txtConfirmPassword.text!)
        {
            return (false,"Confirm password does not match with new password".localized)
        }
        return (true,"")
    }
    
    
    // ----------------------------------------------------
    //MARK:- --------- IBAction Methods ---------
    // ----------------------------------------------------
 
    @IBAction func btnUpdatePasswordTapped(_ sender: Any) {
        guard UserDefaults.standard.object(forKey: UserDefaultKeys.kUserProfile) != nil else { return }
        
        var userModel  = UserData()
        do{
            userModel = try UserDefaults.standard.get(objectType: UserData.self, forKey: UserDefaultKeys.kUserProfile)!
        }catch{
           UtilityClass.showAlert(Message: error.localizedDescription)
            return
        }
        let userID = userModel.iD
        let changePasswordModel = ChangePassword()
        changePasswordModel.NewPassword = txtNewPassword.text ?? ""
        changePasswordModel.OldPassword = txtCurrentPassword.text ?? ""
        changePasswordModel.UserID = userID!

        if(self.ValidationForChangePwd(model: changePasswordModel).0 == false){
            UtilityClass.showAlert(Message: self.ValidationForChangePwd(model: changePasswordModel).1)
        } else{
            UtilityClass.showHUD()

            UserWebserviceSubclass.changePassword(ChangePasswordModel: changePasswordModel) { (json, status, res) in
                
                UtilityClass.hideHUD()
                if status{
                    let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
                    UtilityClass.showAlertWithCompletion(title: "", Message: msg, ButtonTitle: "OK".localized, Completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }else {
                    UtilityClass.showAlertOfAPIResponse(param: res)
                }
            }
        }
    }
}
