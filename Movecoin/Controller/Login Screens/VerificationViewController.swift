//
//  VerificationViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class VerificationViewController: MirroringViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var firstPinView: VKPinCodeView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSendAgian: UIButton!
    
    // ----------------------------------------------------
    //MARK:- --------- Variables ---------
    // ----------------------------------------------------
    
    var signupModel = SignupModel()
    var otp = String()
    var enteredOTP = String()
    var imgProfilePicture : UIImage?
    var isOTPverified = false
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpPinView()
        self.setupFont()
        
        firstPinView.onCodeDidChange = { (pin) in
            print("onCodeDidChange : ", pin)
            self.enteredOTP = pin
        }
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationBarSetUp(title: "Verification Code")
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
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

    // ----------------------------------------------------
    //MARK:- --------- Lifecycle Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnVerifyTapped(_ sender: Any) {
        print("OTP : \(otp)")
        if enteredOTP.count == 0 {
            UtilityClass.showAlert(Message: "Please enter verification code")
//        } else if otp.count != 4 {
//            UtilityClass.showAlert(Message: "Please enter valid verification code")
        } else if enteredOTP == otp {
            webserviceCallForSignup(signupDic: signupModel)
        } else {
             UtilityClass.showAlert(Message: "Invalid verification code")
        }
    }
    
    @IBAction func btnSendAgainTapped(_ sender: Any) {
        self.view.endEditing(true)
        let otpDic = OTPrequestModel()
        otpDic.Email = signupModel.Email
        otpDic.Phone = signupModel.Phone
        webserviceCallForOTPrequest(otpModel: otpDic)
    }
}
// ----------------------------------------------------
// MARK: - --------- Webservice Methods ---------
// ----------------------------------------------------

extension VerificationViewController {
    
    func webserviceCallForSignup(signupDic: SignupModel){
        
        UtilityClass.showHUD()
        
        UserWebserviceSubclass.signup(signupModel: signupDic, image: imgProfilePicture) { (json, status, res) in

            UtilityClass.hideHUD()

            if status{
                let loginResponseModel = LoginResponseModel(fromJson: json)
                UserDefaults.standard.set(loginResponseModel.xApiKey, forKey: UserDefaultKeys.kX_API_KEY)
                UserDefaults.standard.set(true, forKey: UserDefaultKeys.kIsLogedIn)
                do{
                    try UserDefaults.standard.set(object: loginResponseModel.data, forKey: UserDefaultKeys.kUserProfile)
                }catch{
                    UtilityClass.showAlert(Message: error.localizedDescription)
                }
                self.getUserData()
                AppDelegateShared.GoToHome()
            }
            else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func webserviceCallForOTPrequest(otpModel: OTPrequestModel){
        
        UtilityClass.showHUD()
        
        UserWebserviceSubclass.otpSendAgain(otpRequestModel: otpModel){ (json, status, res) in
            
            UtilityClass.hideHUD()
            
            UtilityClass.showAlertOfAPIResponse(param: res)
            
            if status{
                self.otp = json["otp"].stringValue
            }
            else{
                
            }
        }
    }
}
