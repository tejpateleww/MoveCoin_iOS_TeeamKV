//
//  AccountPrivacyViewController.swift
//  Movecoin
//
//  Created by eww090 on 12/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import FirebaseAnalytics
enum PrivacyType : Int {
    case All = 0
    case Friends
    case None
    
    var description: String {
       get {
         switch self {
           case .All:
             return "All"
           case .Friends:
             return "Friends"
           case .None:
             return "No one"
         }
       }
     }
}

class AccountPrivacyViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var tblPrivacy: UITableView!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    //    let pickerView = UIPickerView()
    let array = ["All","Friends","No one"]
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()

    var cellIndexPath = IndexPath()
    var privacyType = PrivacyType(rawValue: 1)
    var pickerSelectedIndex : Int!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        Analytics.logEvent("AccountPrivacyScreen", parameters: nil)

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
        if let index = Int(SingletonClass.SharedInstance.userData!.accountPrivacy) {
            privacyType = PrivacyType(rawValue: index)
        }
        pickerSelectedIndex = privacyType?.rawValue
        
        
        // Toolbar setup
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        let cancelButton = UIBarButtonItem.init(title: "Cancel".localized, style: .done, target: self, action: #selector(onCancelButtonTapped))
        cancelButton.tintColor = UIColor.black
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //a flexible space between the two buttons
        let doneButton = UIBarButtonItem.init(title: "Done".localized, style: .done, target: self, action: #selector(onDoneButtonTapped))
        doneButton.tintColor = UIColor.black
        
        //Add the items to the toolbar
        toolBar.items = [cancelButton, flexSpace, doneButton]
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
        cell.txtPrivacy.isUserInteractionEnabled = false
        cell.switchToggle.layer.cornerRadius = cell.switchToggle.frame.height / 2
        cell.switchToggle.backgroundColor = .gray
        cell.txtPrivacy.text = privacyType?.description.localized
        print("Privacy : ",cell.txtPrivacy.text)
        
        if let privacyStatus = SingletonClass.SharedInstance.userData?.accountPrivacy{
            cell.switchToggle.isOn = privacyStatus == "0" ? false : true
        }
        cell.switchToggle.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        cellIndexPath = indexPath
        picker.delegate = self

        picker.backgroundColor = UIColor.white
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 250)
        
        
        //        toolBar.items = [UIBarButtonItem.init(title: "Done".localized, style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.picker.selectRow(self.privacyType!.rawValue, inComponent: 0, animated: false)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.addSubview(self.picker)
            self.view.addSubview(self.toolBar)
            self.picker.alpha = 1
            self.toolBar.alpha = 1
        }) { status in
             
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- PickerView Methods ---------
// ----------------------------------------------------

extension AccountPrivacyViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    @objc func onDoneButtonTapped() {
        
        
        UIView.animate(withDuration: 0.4, animations: {
            self.toolBar.alpha = 0
            self.picker.alpha = 0
        }) { _ in
            self.toolBar.removeFromSuperview()
            self.picker.removeFromSuperview()
        }
        
        webserviceforPrivacy()
    }
    
    @objc func onCancelButtonTapped() {
        UIView.animate(withDuration: 0.4, animations: {
            self.toolBar.alpha = 0
            self.picker.alpha = 0
        }) { _ in
            self.toolBar.removeFromSuperview()
            self.picker.removeFromSuperview()
        }
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array[row].localized
    }

    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//        let label = UILabel()
//        label.font = UIFont.regular(ofSize: 17)
//        label.text = array[row].localized
//        label.textAlignment = .center
//        return label
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelectedIndex = row
//        privacyType = PrivacyType(rawValue: row)
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
        strParam = NetworkEnvironment.baseURL + ApiKey.accountPrivacy.rawValue + id + "/\(String(pickerSelectedIndex))"
        
        UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
            print(status)
            
            UtilityClass.hideHUD()
            
            if status{
                let cell : AccountPrivacyTableViewCell = self.tblPrivacy.cellForRow(at: self.cellIndexPath) as! AccountPrivacyTableViewCell
                self.privacyType = PrivacyType(rawValue: self.pickerSelectedIndex)
                cell.txtPrivacy.text = self.privacyType?.description.localized
                
                if let userData = SingletonClass.SharedInstance.userData {
                    userData.accountPrivacy = json["account_privacy"].stringValue
                    do{
                        try UserDefaults.standard.set(object: userData, forKey: UserDefaultKeys.kUserProfile)
                        SingletonClass.SharedInstance.userData = userData
                        AppDelegateShared.notificationEnableDisable(notification: userData.notification ?? "0")
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


