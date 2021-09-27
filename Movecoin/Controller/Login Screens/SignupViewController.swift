//
//  SignupViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import ZSWTappableLabel
import ZSWTaggedString
import SafariServices

class SignupViewController: UIViewController,ZSWTappableLabelTapDelegate {
   
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtFullName: TextFieldFont!
    @IBOutlet weak var txtNickname: TextFieldFont!
    @IBOutlet weak var txtEmail: TextFieldFont!
    @IBOutlet weak var txtMobile: TextFieldFont!
    @IBOutlet weak var txtPassword: TextFieldFont!
    @IBOutlet weak var txtConfirmPassword: TextFieldFont!
    @IBOutlet weak var txtGender: TextFieldFont!
    @IBOutlet weak var txtReferral: TextFieldFont!
    
    @IBOutlet weak var lblAccount: LocalizLabel!
    @IBOutlet weak var lblTermsAndConditions: ZSWTappableLabel!
    @IBOutlet weak var btnSignIn: LocalizButton!
    @IBOutlet weak var btnIAgree: UIButton!
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    private var imagePicker : ImagePickerClass!
    var arrayGender = ["Male","Female"]
    lazy var pickerView = UIPickerView()
    var selectedImage : UIImage?
    var userSocialData : UserSocialData?
    var selectedGender : String?
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    
    static let URLAttributeName = NSAttributedString.Key(rawValue: "URL")
    
    enum LinkType: String {
        case Privacy = "privacy"
        case TermsOfService = "tos"
        
        var URL: Foundation.URL {
            switch self {
            case .Privacy:
                return Foundation.URL(string: "https://www.movecoins.net/en/privacy-policy-en/")!
            case .TermsOfService:
                return Foundation.URL(string: "https://www.movecoins.net/terms-conditions/")!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetUp(hidesBackButton: true)
        self.setupView()
        self.setupFont()
        self.setupLabel()
        #if targetEnvironment(simulator)
        setDummy()
        #endif
    }
    
    func setupLabel()
    {
        lblTermsAndConditions.tapDelegate = self
        let options = ZSWTaggedStringOptions(baseAttributes: [
            .font : UIFont.regular(ofSize: 13),
        ])
        options["link"] = .dynamic({ tagName, tagAttributes, stringAttributes in
            guard let typeString = tagAttributes["type"] as? String,
                let type = LinkType(rawValue: typeString) else {
                return [NSAttributedString.Key: AnyObject]()
            }
            
            return [
                .tappableRegion: true,
                .font : UIFont.regular(ofSize: 13),
                .foregroundColor: UIColor.blue,
                SignupViewController.URLAttributeName: type.URL
            ]
        })
        
        let iagreetext = "title_agree_1".localized
        let terms = "Terms and Conditions".localized
        let privacyPolicy = "Privacy Policy".localized
        let and = "and".localized
        let string = NSLocalizedString("\(iagreetext) <link type='tos'>\(terms)</link> \(and) <link type='privacy'>\(privacyPolicy)</link>", comment: "")
        lblTermsAndConditions.attributedText = try? ZSWTaggedString(string: string).attributedString(with: options)
        
        lblTermsAndConditions.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateMylocation()
        if let socialData = userSocialData {
            txtEmail.text = socialData.userEmail
            txtFullName.text = socialData.fullName
            if let url = URL(string: socialData.Profile ) {
                imgProfile.kf.indicatorType = .activity
                imgProfile.kf.setImage(with: url, placeholder: UIImage(named: "m-logo"), options: .none, progressBlock: nil) { (result) in
                    print(result)
                    switch result {
                    case .success(let imageResult) :
                        self.selectedImage = imageResult.image
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height / 2
    }
  
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setupView(){
        pickerView.delegate = self
        
        txtFullName.delegate = self
        txtNickname.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        txtGender.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.profileViewTapped(_:)))
        viewProfile.addGestureRecognizer(tap)
        viewProfile.isUserInteractionEnabled = true
        self.imagePicker = ImagePickerClass(presentationController: self, delegate: self, allowsEditing: false)
    }
    
    func setupFont(){
        lblAccount.font = UIFont.regular(ofSize: 15)
        btnSignIn.titleLabel?.font = UIFont.regular(ofSize: 15)
    }
    
    func setDummy(){
        txtEmail.text = "rahul@gmail.com"
        txtMobile.text = "1234567121"
        txtFullName.text = "Rahul Patel"
        txtNickname.text = "rahul"
        txtPassword.text = "12345678"
        txtConfirmPassword.text = "12345678"
        txtReferral.text = "mvcn7rah"
        
    }
    
    @objc func profileViewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        self.imagePicker.present(from: imgProfile)
    }
    
    func validate() {
        do {
            let fullName = try txtFullName.validatedText(validationType: ValidatorType.fullname)
            let nickName = try txtNickname.validatedText(validationType: ValidatorType.requiredField(field: txtNickname.placeholder!))
            let email = try txtEmail.validatedText(validationType: ValidatorType.email)
            let mobileNumber = try txtMobile.validatedText(validationType: ValidatorType.mobileNumber)
            let password = try txtPassword.validatedText(validationType: ValidatorType.password)
            _ = try txtConfirmPassword.validatedText(validationType: ValidatorType.requiredField(field: txtConfirmPassword.placeholder!))

            if txtPassword.text != txtConfirmPassword.text {
                UtilityClass.showAlert(Message: "Confirm password does not match with password".localized)
                return
            }
            
            if (!btnIAgree.isSelected)
            {
                UtilityClass.showAlert(Message: "Please accept Terms and Conditions and Privacy Policy".localized)
                return
            }
//            else if txtGender.text!.isBlank {
//                UtilityClass.showAlert(Message: "Please select gender".localized)
//                return
//            }
            let signupModel = SignupModel()
            signupModel.FullName = fullName
            signupModel.NickName = nickName
            signupModel.Phone = mobileNumber
            signupModel.Email = email
            signupModel.Password = password
            if let gender = selectedGender {
                signupModel.Gender = (gender == "Male") ? "0" : "1"
            }
            signupModel.ReferralCode = txtReferral.text!
            signupModel.DeviceType = "ios"
            signupModel.SocialID = userSocialData?.userId ?? ""
            signupModel.SocialType = userSocialData?.socialType ?? ""
            if let myLocation = SingletonClass.SharedInstance.myCurrentLocation  {
                signupModel.Latitude = "\(String(describing: myLocation.coordinate.latitude))"
                signupModel.Longitude = "\(String(describing: myLocation.coordinate.longitude))"
            } else {
                signupModel.Latitude = "0"
                signupModel.Longitude = "0"
            }
            signupModel.language = (Localize.currentLanguage() == Languages.English.rawValue) ? 1 : 2
            #if targetEnvironment(simulator)
            // 23.0732727,72.5181843
            signupModel.Latitude = "23.0732727"
            signupModel.Longitude = "72.5181843"
            #endif
            signupModel.DeviceToken = SingletonClass.SharedInstance.DeviceToken
            webserviceCallForOTP(signupDic: signupModel)
        } catch(let error) {
            UtilityClass.showAlert(Message: (error as! ValidationError).message)
        }
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBActions Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnSignInTapped(_ sender: Any) {
      
        if ((self.navigationController?.hasViewController(ofKind: LoginViewController.self)) != nil) {
            self.popViewControllerWithFlipAnimation()
//            self.navigationController?.popViewController(animated: true)
        }else{
            let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let loginController = loginStoryboard.instantiateViewController(withIdentifier: LoginViewController.className) as! LoginViewController
           self.pushViewControllerWithFlipAnimation(viewController: loginController)
        }
    }
    
    @IBAction func btnVerifyTapped(_ sender: Any) {
        self.validate()
    }
    
    
    @IBAction func btnIAgreeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func tappableLabel(_ tappableLabel: ZSWTappableLabel, tappedAt idx: Int, withAttributes attributes: [NSAttributedString.Key : Any] = [:]) {
        guard let URL = attributes[SignupViewController.URLAttributeName] as? URL else {
            return
        }
        UIApplication.shared.open(URL)
    }
    

}

// ----------------------------------------------------
// MARK: - --------- Textfield Delegate Methods ---------
// ----------------------------------------------------

extension SignupViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtGender {
            textField.inputView = pickerView
            if textField.text!.isEmpty {
                textField.text = arrayGender.first?.localized
                selectedGender = arrayGender.first
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPassword || textField == txtConfirmPassword {
            if string == " " {
                return false
            }
        }
        return true
    }
}

// ----------------------------------------------------
// MARK: - --------- Pickerview Delegate Methods ---------
// ----------------------------------------------------

extension SignupViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayGender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayGender[row].localized
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtGender.text = arrayGender[row].localized
        selectedGender = arrayGender[row]
    }
}

// ----------------------------------------------------
// MARK: - --------- ImagePicker Delegate Methods ---------
// ----------------------------------------------------

extension SignupViewController :  ImagePickerDelegate {
    
    func didSelect(image: UIImage?, SelectedTag: Int) {
    
        if(image == nil && SelectedTag == 101){
            self.imgProfile.image = UIImage(named: "m-logo")
            self.selectedImage = nil
            
        }else if image != nil{
            self.imgProfile.image = image
            self.selectedImage = self.imgProfile.image
        }
//        self.selectedImage = self.imgProfile.image
    }
}

// ----------------------------------------------------
// MARK: - --------- Webservice Methods ---------
// ----------------------------------------------------

extension SignupViewController {
    
    func webserviceCallForOTP(signupDic: SignupModel){
        
        UtilityClass.showHUD()
       
        UserWebserviceSubclass.otpRequest(signupModel: signupDic){ (json, status, res) in
            
            UtilityClass.hideHUD()
            Analytics.logEvent(AnalyticsEventSignUp, parameters: [
              AnalyticsParameterMethod: "SimpleSignup"
              ])
            if status{
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
                UtilityClass.showAlertWithCompletion(title: "", Message: msg, ButtonTitle: "OK".localized, Completion: {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: VerificationViewController.className) as! VerificationViewController
                    controller.signupModel = signupDic
                    controller.otp = json["otp"].stringValue
                    controller.imgProfilePicture = self.selectedImage //self.imgProfile.image
                    self.navigationController?.pushViewController(controller, animated: true)
                })
            }
            else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
