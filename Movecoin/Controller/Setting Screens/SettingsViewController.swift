//
//  SettingsViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var tblSettings: UITableView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblVersion: UILabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var settingsArray = ["Notification","Account Privacy","Edit Profile","Change Password","Purchase History","Help","Rate this app","Terms and Conditions","Privacy Policy","Support","Language"]
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupFont()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(title: "Settings")
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        tblSettings.delegate = self
        tblSettings.dataSource = self
        tblSettings.tableFooterView = UIView.init(frame: CGRect.zero)
        
        //        btnLogout.setAttributedTitle(btnLogout.attributedString(), for: .normal)
    }
    
    func setupFont(){
        btnLogout.titleLabel?.font = UIFont.light(ofSize: 20)
        lblVersion.font = UIFont.regular(ofSize: 20)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
       webserviceforNotification()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnLogoutTapped(_ sender: Any) {
        let alert = UIAlertController(title: kAppName, message: "Are you sure you want to logout?", preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "OK", style: .default) { (action) in
            self.webserviceForLogout()
        }
        let btncancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
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
        cell.lblTitle.text = settingsArray[indexPath.row]
        if indexPath.row > 0 {
            cell.switchToggle.isHidden = true
            cell.btnArrow.isHidden = false
        } else{
            cell.switchToggle.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
            cell.switchToggle.layer.cornerRadius = cell.switchToggle.frame.height / 2
            cell.switchToggle.backgroundColor = .gray
            cell.switchToggle.isHidden = false
            cell.btnArrow.isHidden = true
            if let notificationStatus = SingletonClass.SharedInstance.userData?.notification{
                cell.switchToggle.isOn = notificationStatus == "0" ? false : true
            }
        }
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
                
            case .ChangePassword:
                let controller = storyboard.instantiateViewController(withIdentifier: ChangePasswordViewController.className) as! ChangePasswordViewController
                self.navigationController?.pushViewController(controller, animated: true)
                
            case .PurchaseHistory:
                let controller = storyboard.instantiateViewController(withIdentifier: PurchaseHistoryViewController.className) as! PurchaseHistoryViewController
                self.navigationController?.pushViewController(controller, animated: true)
                
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
                    }catch{
                        UtilityClass.showAlert(Message: error.localizedDescription)
                    }
                }
            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}


