//
//  LoginViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AuthenticationServices
import TwitterKit
import TwitterCore
import IQKeyboardManagerSwift

struct UserSocialData {
    var userId: String
    var fullName: String
    var userEmail: String
    var socialType: String
    var Profile : String
}

class LoginViewController: UIViewController, CAAnimationDelegate, TWTRComposerViewControllerDelegate  {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var viewAppleLogin: UIView!
    @IBOutlet weak var appleSigninBtnHeightConstraint: NSLayoutConstraint!
    
    // ----------------------------------------------------
    //MARK:- --------- Variables ---------
    // ----------------------------------------------------
    
     var userSocialData: UserSocialData?
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetUp(hidesBackButton: true)
        self.setupFont()
        setupSOAppleSignIn()
        localizeUI(parentView: self.viewParent)
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localized

        #if targetEnvironment(simulator)
//       setDummy()
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateMylocation()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setDummy(){
        txtEmail.text = "bhumi.j@excellentwebworld.in"
        txtPassword.text = "123456"
    }
    
    func setupFont(){
        lblTitle.font = UIFont.regular(ofSize: 20)
        lblAccount.font = UIFont.regular(ofSize: 18)
        lblOr.font = UIFont.regular(ofSize: 15)
        btnSignUp.titleLabel?.font = UIFont.semiBold(ofSize: 20)
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
            loginModel.language = (Localize.currentLanguage() == Languages.English.rawValue) ? 1 : 2
            #if targetEnvironment(simulator)
            // 23.0732727,72.5181843
            loginModel.Latitude = "23.0732727"
            loginModel.Longitude = "72.5181843"
            #endif
            loginModel.DeviceToken = SingletonClass.SharedInstance.DeviceToken
            webserviceCallForLogin(loginDic: loginModel)
        } catch(let error) {
            UtilityClass.showAlert(Message: (error as! ValidationError).message)
        }
    }
    
    func setupSOAppleSignIn() {
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton()
            authorizationButton.frame = self.viewAppleLogin.bounds//CGRect(x: 0, y: 0, width: 200, height: 40)
//            authorizationButton.center = self.viewAppleLogin.center
            authorizationButton.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
            self.viewAppleLogin.addSubview(authorizationButton)
            
        } else {
            // Fallback on earlier versions
            appleSigninBtnHeightConstraint.constant = 0
        }
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
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
            UtilityClass.alertForLocation(currentVC: self)
        }
       
        (sender as! UIButton).bounceAnimationOnCompletion {
//            UserDefaults.standard.set(true, forKey: UserDefaultKeys.IsLogin)
//            AppDelegateShared.GoToHome()
        }
    }
    
    @IBAction func btnFBTapped(_ sender: Any) {
        
        if !WebService.shared.isConnected {
            UtilityClass.showAlert(Message: "Please check your internet")
            return
        }
        let login = LoginManager()
        login.logOut()
        login.logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
            
            if error != nil {
                //                UIApplication.shared.statusBarStyle = .lightContent
            }
            else if (result?.isCancelled)! {
                //                UIApplication.shared.statusBarStyle = .lightContent
            }else {
                if (result?.grantedPermissions.contains("email"))! {
                    //                    UIApplication.shared.statusBarStyle = .lightContent
                    self.getFBUserData()
                }else {
                    print("you don't have permission")
                }
            }
        }
    }
    
    @IBAction func btnTwitterTapped(_ sender: Any) {
        
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session?.userName ?? "")");
                self.userSocialData = UserSocialData(userId:session?.userID ?? "", fullName: "", userEmail: session?.userName ?? "", socialType: "twitter", Profile:"")
                
                let socialModel = SocialLoginModel()
                socialModel.SocialID = session?.userID ?? ""
                socialModel.Username = session?.userName ?? ""
                socialModel.SocialType = "twitter"
                socialModel.DeviceType = "ios"
                if let myLocation = SingletonClass.SharedInstance.myCurrentLocation  {
                    socialModel.Latitude = "\(String(describing: myLocation.coordinate.latitude))"
                    socialModel.Longitude = "\(String(describing: myLocation.coordinate.longitude))"
                }
                #if targetEnvironment(simulator)
                // 23.0732727,72.5181843
                socialModel.Latitude = "23.0732727"
                socialModel.Longitude = "72.5181843"
                #endif

                self.webserviceCallForSocialLogin(socialModel: socialModel)
            } else {
                print("error: \(error?.localizedDescription ?? "")");
            }
        })
    }
    
    @IBAction func actionHandleAppleSignin(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    
}

// -----------------------------------------------------------------
//MARK:- --------- ASAuthorizationController Delegate Methods ---------
// -----------------------------------------------------------------

extension LoginViewController : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    //For present window
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // ASAuthorizationControllerDelegate function for authorization failed
  @available(iOS 13.0, *)
     func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
         print(error.localizedDescription)
     }
     
     @available(iOS 13.0, *)
     // ASAuthorizationControllerDelegate function for successful authorization
     func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
         if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
             let appleId = appleIDCredential.user
             let appleUserFirstName = appleIDCredential.fullName?.givenName
             let appleUserLastName = appleIDCredential.fullName?.familyName
             let appleUserEmail = appleIDCredential.email
             print(appleId, appleUserFirstName ?? "", appleUserLastName ?? "", appleUserEmail ?? "")
            
            let appleModel = AppleDetailsModel()
            appleModel.apple_id = appleId
            appleModel.email = appleUserEmail ?? ""
            appleModel.first_name = appleUserFirstName ?? ""
            appleModel.last_name = appleUserLastName ?? ""
            
            self.webserviceCallForAppleLogin(appleModel: appleModel)
             
//             self.checkAppleId(credentials: appleIDCredential)
         }
         else if let passwordCredential = authorization.credential as? ASPasswordCredential {
             let appleUsername = passwordCredential.user
             let applePassword = passwordCredential.password
             
             print(appleUsername, applePassword)
         }
     }
}

// ----------------------------------------------------
//MARK:- --------- Social Media Methods ---------
// ----------------------------------------------------

extension LoginViewController {
    
    func getFBUserData() {
       
        var parameters = [AnyHashable: Any]()
        parameters["fields"] = "first_name, last_name, email, id, picture.type(large)"
        
        GraphRequest.init(graphPath: "me", parameters: parameters as! [String : Any]).start { (connection, result, error) in
            if error == nil {
                
                print("\(#function) \(result!)")
                let dictData = result as! [String : AnyObject]
                let strFirstName = String(describing: dictData["first_name"]!)
                let strLastName = String(describing: dictData["last_name"]!)
                let strEmail = String(describing: dictData["email"]!)
                let strUserId = String(describing: dictData["id"]!)
                
                let profile = ((dictData["picture"] as! [String:AnyObject])["data"]  as! [String:AnyObject])["url"] as! String
                print(profile)
//                let profileUrl = "http://graph.facebook.com/519887295486608/picture?type=large"
                
                self.userSocialData = UserSocialData(userId:strUserId, fullName: "\(strFirstName) \(strLastName)", userEmail: strEmail, socialType: "facebook", Profile:profile)
                
                let socialModel = SocialLoginModel()
                socialModel.SocialID = strUserId
                socialModel.Username = strEmail
                socialModel.SocialType = "facebook"
                socialModel.DeviceType = "ios"
                if let myLocation = SingletonClass.SharedInstance.myCurrentLocation  {
                    socialModel.Latitude = "\(String(describing: myLocation.coordinate.latitude))"
                    socialModel.Longitude = "\(String(describing: myLocation.coordinate.longitude))"
                }
                #if targetEnvironment(simulator)
                // 23.0732727,72.5181843
                socialModel.Latitude = "23.0732727"
                socialModel.Longitude = "72.5181843"
                #endif

                self.webserviceCallForSocialLogin(socialModel: socialModel)
            }
            else{
                print(error?.localizedDescription ?? "")
            }
        }
    }
}

// ----------------------------------------------------
// MARK: - --------- Webservice Methods ---------
// ----------------------------------------------------

extension LoginViewController {
    
    func webserviceCallForLogin(loginDic: LoginModel){
        
        UtilityClass.showHUD()
        
        UserWebserviceSubclass.login(loginModel: loginDic) { (json, status, res) in
            
            UtilityClass.hideHUD()
           
            if status{
                let loginResponseModel = LoginResponseModel(fromJson: json)
                UserDefaults.standard.set(loginResponseModel.xApiKey, forKey: UserDefaultKeys.kX_API_KEY)
                UserDefaults.standard.set(true, forKey: UserDefaultKeys.kIsLogedIn)
               
                do{
                    try UserDefaults.standard.set(object: loginResponseModel.data, forKey: UserDefaultKeys.kUserProfile)
                    SingletonClass.SharedInstance.userData = loginResponseModel.data
//                    AppDelegateShared.notificationEnableDisable(notification: SingletonClass.SharedInstance.userData?.notification ?? "0")
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
    
    func webserviceCallForSocialLogin(socialModel : SocialLoginModel) {
        
          UtilityClass.showHUD()
        
           UserWebserviceSubclass.socialModel(socialModel: socialModel) { (json, status, res) in
               
            UtilityClass.hideHUD()
            
            if status{
                let loginResponseModel = LoginResponseModel(fromJson: json)
                UserDefaults.standard.set(loginResponseModel.xApiKey, forKey: UserDefaultKeys.kX_API_KEY)
                UserDefaults.standard.set(true, forKey: UserDefaultKeys.kIsLogedIn)
               
                do{
                    try UserDefaults.standard.set(object: loginResponseModel.data, forKey: UserDefaultKeys.kUserProfile)
                    SingletonClass.SharedInstance.userData = loginResponseModel.data
                    AppDelegateShared.notificationEnableDisable(notification: SingletonClass.SharedInstance.userData?.notification ?? "0")
                }catch{
                    UtilityClass.showAlert(Message: error.localizedDescription)
                }
                AppDelegateShared.GoToHome()
            }
            else{
                if ((self.navigationController?.hasViewController(ofKind: SignupViewController.self)) != nil) {
                    for controller in self.navigationController?.viewControllers ?? [] {
                        if(controller.isKind(of: SignupViewController.self)) {
                            let signup = controller as! SignupViewController
                            signup.userSocialData = self.userSocialData
                            self.popViewControllerWithFlipAnimation()
                            break
                        }
                    }
                }else{
                    let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
                    let signupController = loginStoryboard.instantiateViewController(withIdentifier: SignupViewController.className) as! SignupViewController
                    signupController.userSocialData = self.userSocialData
                    self.pushViewControllerWithFlipAnimation(viewController: signupController)
                }
            }
        }
    }
    
    func webserviceCallForAppleLogin(appleModel : AppleDetailsModel) {
        
        UtilityClass.showHUD()
        
        UserWebserviceSubclass.appleLogin(appleModel: appleModel){ (json, status, res) in
            
            UtilityClass.hideHUD()
           
            if status{
                
                let responseModel = AppleLoginResponseModel(fromJson: json)
            
                let socialModel = SocialLoginModel()
                socialModel.SocialID = responseModel.message.appleId
                socialModel.Username = responseModel.message.email
                socialModel.SocialType = "apple"
                socialModel.DeviceType = "ios"
                if let myLocation = SingletonClass.SharedInstance.myCurrentLocation  {
                    socialModel.Latitude = "\(String(describing: myLocation.coordinate.latitude))"
                    socialModel.Longitude = "\(String(describing: myLocation.coordinate.longitude))"
                }
                #if targetEnvironment(simulator)
                // 23.0732727,72.5181843
                socialModel.Latitude = "23.0732727"
                socialModel.Longitude = "72.5181843"
                #endif
                
                self.userSocialData = UserSocialData(userId:responseModel.message.appleId, fullName: "\(responseModel.message.firstName ?? "") \(responseModel.message.lastName ?? "")", userEmail: responseModel.message.email, socialType: "apple", Profile:"")
                
                self.webserviceCallForSocialLogin(socialModel: socialModel)
            }
        }
    }
}
