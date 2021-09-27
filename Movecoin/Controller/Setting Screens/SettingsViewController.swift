//
//  SettingsViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import StoreKit
import FirebaseAnalytics
class SettingsViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var tblSettings: UITableView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblVersion: UILabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var settingsArray = ["Notification","Account Privacy","Edit Profile","Purchase History" ,"Total Redeem","Block List","Help/Support","Terms and Conditions","Privacy Policy","Language","Rate this app"]
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupFont()
        Analytics.logEvent("SettingsScreen", parameters: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(title: "Settings")
        self.statusBarSetUp(backColor: .clear)
//        self.navigationController?.navigationBar.isHidden = false


    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        lblVersion.text = "Version - ".localized + kAPPVesion

        tblSettings.delegate = self
        tblSettings.dataSource = self
        tblSettings.tableFooterView = UIView.init(frame: CGRect.zero)
        
        tblSettings.semanticContentAttribute = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .forceRightToLeft : .forceLeftToRight
        
        
        /*       UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
         switch setttings.authorizationStatus{
         case .denied:
         print("setting has been disabled")
         if let notificationStatus = SingletonClass.SharedInstance.userData?.notification{
         if notificationStatus == "1" {
         self.webserviceforNotification()
         }
         }
         case .notDetermined:
         print("something vital went wrong here")
         case .provisional:
         print("provisional")
         case .authorized:
         print("setting has been authorized")
         @unknown default:
         return
         }
         }
         */
        //        btnLogout.setAttributedTitle(btnLogout.attributedString(), for: .normal)
    }
    
    func setupFont(){
        btnLogout.titleLabel?.font = UIFont.light(ofSize: 20)
        lblVersion.font = UIFont.regular(ofSize: 20)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        
        UNUserNotificationCenter.current().getNotificationSettings(){ (settings) in
            
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    print("authorized")
                    mySwitch.isOn = !mySwitch.isOn
                    self.webserviceforNotification()
                    
                default :
                    
                    mySwitch.isOn = false
                    
                    UtilityClass.showAlert(Message: "Please enable notifications from iPhone settings".localized)
                }
            }
        }
    }
    
    @objc func languageChanged(sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 1){
//            Localize.setCurrentLanguage(Languages.English.rawValue)
            webserviceForChangeLanguage(language: "1")
        }else{
//            Localize.setCurrentLanguage(Languages.Arabic.rawValue)
            webserviceForChangeLanguage(language: "2")
        }
    }

    func changeLanguage(){

        self.navigationBarSetUp(title: "Settings",hidesBackButton: true)
        self.navigationBarSetUp(title: "Settings",hidesBackButton: false)
        UIView.appearance().semanticContentAttribute = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .forceRightToLeft : .forceLeftToRight
        tblSettings.semanticContentAttribute = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .forceRightToLeft : .forceLeftToRight
        lblVersion.text = "Version - ".localized + kAPPVesion
        tblSettings.reloadData()
    }
    
    func reloadLocalizationEffect(cell : SettingsTableViewCell){
        cell.lblTitle.textAlignment =  (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        let sendImg = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? (UIImage(named: "arrow-left")) : (UIImage(named: "arrow-right"))
        cell.btnArrow.setImage(sendImg, for: .normal)
    }
    
    func rateApp() {
        guard let url = URL(string: "https://itunes.apple.com/app/id\(kAppID)?action=write-review") else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)

        } else {
            UIApplication.shared.openURL(url)
        }
    }
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnLogoutTapped(_ sender: Any) {
        let alert = UIAlertController(title: kAppName.localized, message: "Are you sure you want to logout?".localized, preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "OK".localized, style: .default) { (action) in
            self.webserviceForLogout()
        }
        let btncancel = UIAlertAction(title: "Cancel".localized, style: .default) { (cancel) in
            self.dismiss(animated: true, completion:nil)
        }
        alert.addAction(btnOk)
        alert.addAction(btncancel)
        alert.modalPresentationStyle = .overCurrentContext
        self.present(alert, animated: true, completion: nil)
    }
}

// ----------------------------------------------------
//MARK:- --------- Tableview Delegate Methods ---------
// ----------------------------------------------------

extension SettingsViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className) as! SettingsTableViewCell
        cell.selectionStyle = .none
        cell.lblTitle.text = settingsArray[indexPath.row].localized
        reloadLocalizationEffect(cell: cell)

        if let option = SettingsOptions(rawValue: indexPath.row) {
            switch option {
                
            case .Notification :
                cell.switchToggle.isHidden = false
                cell.btnArrow.isHidden = true
                cell.segmentControl.isHidden = true
                
                cell.switchToggle.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
                cell.switchToggle.layer.cornerRadius = cell.switchToggle.frame.height / 2
                cell.switchToggle.backgroundColor = .gray
                if let notificationStatus = SingletonClass.SharedInstance.userData?.notification{
                    cell.switchToggle.isOn = notificationStatus == "0" ? false : true
                }
            case .Language:
                cell.switchToggle.isHidden = true
                cell.btnArrow.isHidden = true
                cell.segmentControl.isHidden = false
                
                cell.segmentControl.selectedSegmentIndex = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? 0 : 1
                cell.segmentControl.addTarget(self, action: #selector(languageChanged), for: UIControl.Event.valueChanged)
            default :
                cell.switchToggle.isHidden = true
                cell.btnArrow.isHidden = false
                cell.segmentControl.isHidden = true
            }
        }
        /*        if indexPath.row > 0 {
         cell.switchToggle.isHidden = true
         cell.btnArrow.isHidden = false
         cell.segmentControl.isHidden = true
         } else{
         cell.switchToggle.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
         cell.switchToggle.layer.cornerRadius = cell.switchToggle.frame.height / 2
         cell.switchToggle.backgroundColor = .gray
         cell.switchToggle.isHidden = false
         cell.btnArrow.isHidden = true
         cell.segmentControl.isHidden = true
         if let notificationStatus = SingletonClass.SharedInstance.userData?.notification{
         cell.switchToggle.isOn = notificationStatus == "0" ? false : true
         }
         } */
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let option = SettingsOptions(rawValue: indexPath.row) {
            switch option {
                
            case .AccountPrivacy:
                let controller = storyboard.instantiateViewController(withIdentifier: AccountPrivacyViewController.className) as! AccountPrivacyViewController
                self.navigationController?.pushViewController(controller, animated: true)
                
            case .EditProfile:
                let controller = storyboard.instantiateViewController(withIdentifier: EditProfileViewController.className) as! EditProfileViewController
                self.navigationController?.pushViewController(controller, animated: true)
                
                //            case .ChangePassword:
                //                let controller = storyboard.instantiateViewController(withIdentifier: ChangePasswordViewController.className) as! ChangePasswordViewController
                //                self.navigationController?.pushViewController(controller, animated: true)
                
            case .PurchaseHistory:
                let controller = storyboard.instantiateViewController(withIdentifier: PurchaseHistoryViewController.className) as! PurchaseHistoryViewController
                self.navigationController?.pushViewController(controller, animated: true)
                
            case .TotalRedeem:
                let controller = storyboard.instantiateViewController(withIdentifier: TotalRedeemVC.className) as! TotalRedeemVC
                self.navigationController?.pushViewController(controller, animated: true)
            case .BlockList:
                let controller = storyboard.instantiateViewController(withIdentifier: BlockedListViewController.className) as! BlockedListViewController
                self.navigationController?.pushViewController(controller, animated: true)
                
            case .Help:
                let controller = storyboard.instantiateViewController(withIdentifier: WebViewController.className) as! WebViewController
                controller.documentType = DocumentType(rawValue: "Help/Support")
                self.navigationController?.pushViewController(controller, animated: true)
                
            case .TermsAndConditions:
                let controller = storyboard.instantiateViewController(withIdentifier: WebViewController.className) as! WebViewController
                controller.documentType = DocumentType(rawValue: "Terms and Conditions")
                self.navigationController?.pushViewController(controller, animated: true)
                
            case .PrivacyPolicy:
                let controller = storyboard.instantiateViewController(withIdentifier: WebViewController.className) as! WebViewController
                controller.documentType = DocumentType(rawValue: "Privacy Policy")
                self.navigationController?.pushViewController(controller, animated: true)
                
            case .RateApp:
                self.rateApp()
//                SKStoreReviewController.requestReview()
                
            default :
                break
                
            }
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension SettingsViewController {
    
    func webserviceForChangeLanguage(language : String){
        
        UtilityClass.showHUD()
        
        var strParam = String()
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
        strParam = NetworkEnvironment.baseURL + ApiKey.updateLanguage.rawValue + "\(id)/\(language)"
        
        UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
            print(status)
            
            UtilityClass.hideHUD()
            
            if status{
                let lang = (Localize.currentLanguage() == Languages.English.rawValue) ? Languages.Arabic.rawValue : Languages.English.rawValue
                Localize.setCurrentLanguage(lang)
                self.changeLanguage()
            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    
    func webserviceforNotification(){
        
        UtilityClass.showHUD()
        
        var strParam = String()
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
        strParam = NetworkEnvironment.baseURL + ApiKey.notification.rawValue + id
        
        UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
            print(status)
            
            UtilityClass.hideHUD()
            
            if status{
                if let userData = SingletonClass.SharedInstance.userData {
                    userData.notification = json["notification"].stringValue
                    do{
                        try UserDefaults.standard.set(object: userData, forKey: UserDefaultKeys.kUserProfile)
                        SingletonClass.SharedInstance.userData = userData
                        AppDelegateShared.notificationEnableDisable(notification: userData.notification ?? "0")
//                        DispatchQueue.main.async {
                            self.tblSettings.reloadData()
                            //                            self.tblSettings.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
//                        }
                    }catch{
                        UtilityClass.showAlert(Message: error.localizedDescription)
                    }
                }
            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func webserviceForLogout(){
        
        guard let userData = SingletonClass.SharedInstance.userData  else { return }
        
        UtilityClass.showHUD()
        guard let xApiKey = UserDefaults.standard.value(forKey: UserDefaultKeys.kX_API_KEY) else { return }
        
        let logout = userData.iD + "/\(xApiKey)"
        UserWebserviceSubclass.Logout(strURL: logout){ (json, status, res) in
            
            UtilityClass.hideHUD()
            
            if status {
                UserDefaults.standard.set(false, forKey: UserDefaultKeys.kIsLogedIn)
                SingletonClass.SharedInstance.singletonClear()
                //                self.removeAllSocketFromMemory()
                AppDelegateShared.GoToLogout()
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}

