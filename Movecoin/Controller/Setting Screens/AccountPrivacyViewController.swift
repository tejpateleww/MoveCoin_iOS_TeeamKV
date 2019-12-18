//
//  AccountPrivacyViewController.swift
//  Movecoin
//
//  Created by eww090 on 12/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class AccountPrivacyViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var tblPrivacy: UITableView!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
   
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(title: "Account Privacy")
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        tblPrivacy.delegate = self
        tblPrivacy.dataSource = self
        tblPrivacy.rowHeight = UITableView.automaticDimension
        tblPrivacy.estimatedRowHeight = 120
        tblPrivacy.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
       webserviceforPrivacy()
    }
}

// ----------------------------------------------------
//MARK:- --------- Tableview Delegate Methods ---------
// ----------------------------------------------------

extension AccountPrivacyViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountPrivacyTableViewCell.className) as! AccountPrivacyTableViewCell
        cell.selectionStyle = .none
        cell.switchToggle.layer.cornerRadius = cell.switchToggle.frame.height / 2
        cell.switchToggle.backgroundColor = .gray
       if let privacyStatus = SingletonClass.SharedInstance.userData?.accountPrivacy{
           cell.switchToggle.isOn = privacyStatus == "0" ? false : true
       }
         cell.switchToggle.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        return cell
    }
}

// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension AccountPrivacyViewController {
    
    func webserviceforPrivacy(){
        
        UtilityClass.showHUD()
        
        var strParam = String()
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
        strParam = NetworkEnvironment.baseURL + ApiKey.accountPrivacy.rawValue + id
        
        UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
            print(status)
            
            UtilityClass.hideHUD()
            
            if status{
                if let userData = SingletonClass.SharedInstance.userData {
                    userData.accountPrivacy = json["account_privacy"].stringValue
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


