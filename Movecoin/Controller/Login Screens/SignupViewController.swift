//
//  SignupViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtNickname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var btnSignIn: UIButton!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    
    private var imagePicker : ImagePickerClass!
    var arrayGender = ["Male","Female"]
    lazy var pickerView = UIPickerView()
    var selectedImage : UIImage?
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupFont()
        #if targetEnvironment(simulator)
        setDummy()
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationBarSetUp(isHidden: true)
        self.updateMylocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height / 2
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
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
        btnSignIn.titleLabel?.font = UIFont.semiBold(ofSize: 15)
    }
    
    func setDummy(){
        txtEmail.text = "rahul@excellentwebworld.com"
        txtMobile.text = "1234567121"
        txtFullName.text = "aa com"
        txtNickname.text = "a"
        txtPassword.text = "123456"
        txtConfirmPassword.text = "123456"
    }
    
    @objc func profileViewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        self.imagePicker.present(from: imgProfile)
    }
    
    func validate() {
        do {
            let fullName = try txtFullName.validatedText(validationType: ValidatorType.fullname)
            if txtNickname.text!.isBlank {
                UtilityClass.showAlert(Message: "Please enter nickname")
                return
            }
            let email = try txtEmail.validatedText(validationType: ValidatorType.email)
            let mobileNumber = try txtMobile.validatedText(validationType: ValidatorType.mobileNumber)
            let password = try txtPassword.validatedText(validationType: ValidatorType.password)
            if txtConfirmPassword.text?.isBlank ?? true {
                UtilityClass.showAlert(Message: "Please enter confirm password")
                return
            }else if txtPassword.text != txtConfirmPassword.text {
                UtilityClass.showAlert(Message: "Confirm password does not match with password")
                return
            } else if txtGender.text!.isBlank {
                UtilityClass.showAlert(Message: "Please select gender")
                return
            }
            let signupModel = SignupModel()
            signupModel.FullName = fullName
            signupModel.NickName = txtNickname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            signupModel.Phone = mobileNumber
            signupModel.Email = email
            signupModel.Password = password
            signupModel.Gender = txtGender.text!
            signupModel.DeviceType = "ios"
            if let myLocation = SingletonClass.SharedInstance.myCurrentLocation  {
                signupModel.Latitude = "\(String(describing: myLocation.coordinate.latitude))"
                signupModel.Longitude = "\(String(describing: myLocation.coordinate.longitude))"
            }
            #if targetEnvironment(simulator)
            // 23.0732727,72.5181843
            signupModel.Latitude = "23.0732727"
            signupModel.Longitude = "72.5181843"
            #endif
            signupModel.DeviceToken = SingletonClass.SharedInstance.DeviceToken
//            if let token = UserDefaults.standard.object(forKey: UserDefaultKeys.kDeviceToken) as? String{
//                signupModel.DeviceToken =  token
//            }
            webserviceCallForOTP(signupDic: signupModel)
        } catch(let error) {
            UtilityClass.showAlert(Message: (error as! ValidationError).message)
        }
    }
    
    // ----------------------------------------------------
    // MARK: - IBActions Methods
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
        if UpdateLocationClass.sharedLocationInstance.checkLocationPermission() {
            self.validate()
        } else {
            UtilityClass.alertForLocation(currentVC: self)
//            UtilityClass.showAlert(Message: "\(kAppName) would like to access your location, please enable location permission to move forward")
        }
    }
}

// ----------------------------------------------------
// MARK: - Webservice Methods
// ----------------------------------------------------

extension SignupViewController {
    
    func webserviceCallForOTP(signupDic: SignupModel){
        
        UtilityClass.showHUD()
       
        UserWebserviceSubclass.otpRequest(signupModel: signupDic){ (json, status, res) in
            
            UtilityClass.hideHUD()
           
            if status{

                UtilityClass.showAlertWithCompletion(title: "", Message: json["message"].stringValue, ButtonTitle: "OK", Completion: {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: VerificationViewController.className) as! VerificationViewController
                    controller.signupModel = signupDic
                    controller.otp = json["otp"].stringValue
                    controller.imgProfilePicture = self.selectedImage
                    self.navigationController?.pushViewController(controller, animated: true)
                })
            }
            else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}

extension SignupViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtGender {
            textField.inputView = pickerView
            if textField.text!.isEmpty {
                textField.text = arrayGender.first
            }
        }
    }
}

extension SignupViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayGender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayGender[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtGender.text = arrayGender[row]
    }
}

//MARK:- ImagePicker Delegate Methods

extension SignupViewController :  ImagePickerDelegate {
    
    func didSelect(image: UIImage?, SelectedTag: Int) {
    
        if image != nil{
            self.imgProfile.image = image
            self.selectedImage = image
        }
    }
}
