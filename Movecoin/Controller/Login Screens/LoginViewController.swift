//
//  LoginViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, CAAnimationDelegate {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblOr: UILabel!
    
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
        setDummy()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateMylocation()
        navigationBarSetUp(isHidden: true)
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setDummy(){
        txtEmail.text = "rahul@excellentwebworld.com"
        txtPassword.text = "123456"
    }
    
    func setupFont(){
        lblTitle.font = UIFont.regular(ofSize: 20)
        lblAccount.font = UIFont.light(ofSize: 15)
        lblOr.font = UIFont.regular(ofSize: 15)
        btnSignUp.titleLabel?.font = UIFont.light(ofSize: 20)
        btnForgotPassword.titleLabel?.font = UIFont.bold(ofSize: 15)
    }
    
    func validate() {
        do {
            let email = try txtEmail.validatedText(validationType: ValidatorType.email)
            let password = try txtPassword.validatedText(validationType: ValidatorType.password)
            let loginModel = LoginModel()
            loginModel.Email = email
            loginModel.Password = password
            loginModel.DeviceType = "ios"
            if let myLocation = SingletonClass.SharedInstance.myCurrentLocation  {
                loginModel.Latitude = "\(String(describing: myLocation.coordinate.latitude))"
                loginModel.Longitude = "\(String(describing: myLocation.coordinate.longitude))"
            }
            #if targetEnvironment(simulator)
            // 23.0732727,72.5181843
            loginModel.Latitude = "23.0732727"
            loginModel.Longitude = "72.5181843"
            #endif
            loginModel.DeviceToken = SingletonClass.SharedInstance.DeviceToken
//            if let token = UserDefaults.standard.object(forKey: UserDefaultKeys.kDeviceToken) as? String{
//                loginModel.DeviceToken =  token
//            }
            webserviceCallForLogin(loginDic: loginModel)
        } catch(let error) {
            UtilityClass.showAlert(Message: (error as! ValidationError).message)
        }
    }
    
    // ----------------------------------------------------
    // MARK: - IBAction Methods
    // ----------------------------------------------------
    
    @IBAction func btnSignUpTapped(_ sender: Any) {
        if ((self.navigationController?.hasViewController(ofKind: SignupViewController.self)) != nil) {
            self.popViewControllerWithFlipAnimation()
        }else{
            let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let signupController = loginStoryboard.instantiateViewController(withIdentifier: SignupViewController.className) as! SignupViewController
            self.pushViewControllerWithFlipAnimation(viewController: signupController)
        }
    }
    @IBAction func btnSignInTapped(_ sender: Any) {
        if UpdateLocationClass.sharedLocationInstance.checkLocationPermission() {
             self.validate()
        } else {
//            UtilityClass.showAlertWithCompletion(title: kAppName, Message: "would like to access your location, please enable location permission to move forward", ButtonTitle: "OK", Completion: {})
            UtilityClass.alertForLocation(currentVC: self)
        }
       
        (sender as! UIButton).bounceAnimationOnCompletion {
//            UserDefaults.standard.set(true, forKey: UserDefaultKeys.IsLogin)
//            AppDelegateShared.GoToHome()
            
        }
    }
}

// ----------------------------------------------------
// MARK: - Webservice Methods
// ----------------------------------------------------

extension LoginViewController {
    
    func webserviceCallForLogin(loginDic: LoginModel){
        
        UtilityClass.showHUD()
        
        UserWebserviceSubclass.login(loginModel: loginDic) { (json, status, res) in
            
            UtilityClass.hideHUD()
            print(json)
            
            if status{
                let loginResponseModel = LoginResponseModel(fromJson: json)
                UserDefaults.standard.set(loginResponseModel.xApiKey, forKey: UserDefaultKeys.kX_API_KEY)
                UserDefaults.standard.set(true, forKey: UserDefaultKeys.kIsLogedIn)
               
                do{
                    try UserDefaults.standard.set(object: loginResponseModel.data, forKey: UserDefaultKeys.kUserProfile)
                    SingletonClass.SharedInstance.userData = loginResponseModel.data
                }catch{
                    UtilityClass.showAlert(Message: error.localizedDescription)
                }
                AppDelegateShared.GoToHome()
            }
            else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
