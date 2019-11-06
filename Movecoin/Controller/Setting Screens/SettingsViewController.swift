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
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var tblSettings: UITableView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblVersion: UILabel!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    var settingsArray = ["Notification","Account Privacy","Edit Profile","Change Password","Purchase History","Help","Rate this app","Terms and Conditions","Privacy Policy","Support","Language"]
    
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupFont()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(isHidden: false, title: "Settings", hidesBackButton: false)
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
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
    
    // ----------------------------------------------------
    // MARK: - IBAction Methods
    // ----------------------------------------------------
    
    @IBAction func btnLogoutTapped(_ sender: Any) {
        let alert = UIAlertController(title: kAppName, message: "Are you sure you want to logout?", preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "OK", style: .default) { (action) in
             AppDelegateShared.GoToLogout()
        }
        let btncancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
            self.dismiss(animated: true, completion:nil)
        }
        alert.addAction(btnOk)
        alert.addAction(btncancel)
        self.present(alert, animated: true, completion: nil)
    }
}

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
            cell.switchToggle.isHidden = false
            cell.btnArrow.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
        if let option = SettingsOptions(rawValue: indexPath.row) {
            switch option {
            case .Notification:
                break
                
            case .AccountPrivacy:
                let controller = storyboard.instantiateViewController(withIdentifier: AccountPrivacyViewController.className) as! AccountPrivacyViewController
                self.navigationController?.pushViewController(controller, animated: true)
                break
                
            case .EditProfile:
                let controller = storyboard.instantiateViewController(withIdentifier: EditProfileViewController.className) as! EditProfileViewController
                self.navigationController?.pushViewController(controller, animated: true)
                break
                
            case .ChangePassword:
                let controller = storyboard.instantiateViewController(withIdentifier: ChangePasswordViewController.className) as! ChangePasswordViewController
                self.navigationController?.pushViewController(controller, animated: true)
                break
                
            case .PurchaseHistory:
                let controller = storyboard.instantiateViewController(withIdentifier: PurchaseHistoryViewController.className) as! PurchaseHistoryViewController
                self.navigationController?.pushViewController(controller, animated: true)
                break
                
            case .Help:
                break
                
            case .RateApp:
                break
                
            case .TermsAndConditions:
                break
                
            case .PrivacyPolicy:
                break
                
            case . Support:
                break
                
            case .Language:
                break
                
            }
        }
    }
}


