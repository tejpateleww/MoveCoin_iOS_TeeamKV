//
//  EditProfileViewController.swift
//  Movecoin
//
//  Created by eww090 on 22/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // ----------------------------------------------------
    //MARK:- --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    
    @IBOutlet weak var txtNickName: ThemeTextfield!
    @IBOutlet weak var txtEmail: ThemeTextfield!
    @IBOutlet weak var txtGender: ThemeTextfield!
    @IBOutlet weak var txtMobile: ThemeTextfield!
    @IBOutlet weak var txtDob: ThemeTextfield!
    @IBOutlet weak var txtHeight: ThemeTextfield!
    @IBOutlet weak var txtWeight: ThemeTextfield!
    
    // ----------------------------------------------------
    //MARK:- --------- Variables ---------
    // ----------------------------------------------------
    
    private var imagePicker : ImagePickerClass!
    var selectedImage : UIImage?
    var isRemovePhoto = false
    var selectedGender : String?
    
    let pickerView = UIPickerView()
    let datePickerView = UIDatePicker()

    var arrayGender = ["Male","Female"]
    let feetList = Array(3...9)
    let inchList = Array(0...11)
    var numberOfComponents = 1
    var selectedHeightComponents = [String]()
    
    // ----------------------------------------------------
    // MARK: - --------- Lifecycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        localizeUI(parentView: self.viewParent)
        self.setupView()
        self.updateMylocation()
        setupProfileData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(title: "Edit Profile")
    }
    
    // ----------------------------------------------------
    //MARK:- --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setupView(){
        pickerView.delegate = self
        datePickerView.datePickerMode = .date
        datePickerView.maximumDate = Date()
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        txtNickName.delegate = self
        txtEmail.delegate = self
        txtMobile.delegate = self
        txtDob.delegate = self
        txtHeight.delegate = self
        txtWeight.delegate = self
        txtGender.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.profileViewTapped(_:)))
        viewProfile.addGestureRecognizer(tap)
        viewProfile.isUserInteractionEnabled = true
        self.imagePicker = ImagePickerClass(presentationController: self, delegate: self, allowsEditing: false)
    }
    
    @objc func profileViewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        self.imagePicker.present(from: imgProfilePicture)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        dateFormatter.dateFormat = DateFomateKeys.displayDate
        txtDob.text = dateFormatter.string(from: sender.date)
    }
    
    func setupProfileData(){
        
        if let userData = SingletonClass.SharedInstance.userData {
            txtNickName.text = userData.nickName
            txtMobile.text = userData.phone
            txtEmail.text = userData.email
            txtGender.text = (userData.updateGender == "0") ? "Male".localized : "Female".localized
            txtHeight.text = userData.height + " cm".localized
            txtWeight.text = userData.weight + " kg".localized
            if userData.dateOfBirth != "0000-00-00" {
                if let dob = UtilityClass.changeDateFormateFrom(dateString: userData.dateOfBirth, fromFormat: DateFomateKeys.apiDOB, withFormat: DateFomateKeys.displayDate) {
                    txtDob.text = dob
                }
            }
            
            if let height = txtHeight.text {
                if !height.isBlank {
                    selectedHeightComponents = height.components(separatedBy: CharacterSet(charactersIn: "'"))
                }
            }
        }
        
        if let url = URL(string: SingletonClass.SharedInstance.userData?.profilePicture ?? "" ) {
            imgProfilePicture.kf.indicatorType = .activity
            imgProfilePicture.kf.setImage(with: url, placeholder: UIImage(named: "m-logo"))
        }
    }
    
    func validate() {
        do {
            let email = try txtEmail.validatedText(validationType: ValidatorType.email)
            let mobileNumber = try txtMobile.validatedText(validationType: ValidatorType.mobileNumber)
        
            let editModel = EditProfileModel()
            editModel.UserID = SingletonClass.SharedInstance.userData?.iD ?? ""
            editModel.NickName = txtNickName.text ?? ""
            editModel.Phone = mobileNumber
            editModel.Email = email
            editModel.Gender = (selectedGender == "Male") ? "0" : "1"
            editModel.Height = txtHeight.text?.replacingOccurrences(of: " cm".localized, with: "") ?? ""
            editModel.Weight = txtWeight.text?.replacingOccurrences(of: " kg".localized, with: "") ?? ""
            if isRemovePhoto {
                editModel.remove_photo = 1
            }
            if let dob = UtilityClass.changeDateFormateFrom(dateString: txtDob.text ?? "", fromFormat: DateFomateKeys.displayDate, withFormat: DateFomateKeys.apiDOB) {
                editModel.DateOfBirth = dob
            }
            editModel.DeviceType = "ios"
            if let myLocation = SingletonClass.SharedInstance.myCurrentLocation  {
                editModel.Latitude = "\(String(describing: myLocation.coordinate.latitude))"
                editModel.Longitude = "\(String(describing: myLocation.coordinate.longitude))"
            }
            #if targetEnvironment(simulator)
            // 23.0732727,72.5181843
            editModel.Latitude = "23.0732727"
            editModel.Longitude = "72.5181843"
            #endif
            editModel.DeviceToken = SingletonClass.SharedInstance.DeviceToken
            webserviceCallForEditProfile(editProfileDic: editModel)
        } catch(let error) {
            UtilityClass.showAlert(Message: (error as! ValidationError).message)
        }
    }
    
    // ----------------------------------------------------
    //MARK:- --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        if UpdateLocationClass.sharedLocationInstance.checkLocationPermission() {
            self.validate()
        } else {
            UtilityClass.alertForLocation(currentVC: self)
//            UtilityClass.showAlert(Message: "\(kAppName) would like to access your location, please enable location permission to move forward")
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- Textfield Delegate Methods ---------
// ----------------------------------------------------

extension EditProfileViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtGender {
            textField.inputView = pickerView
            numberOfComponents = 1
            
            if textField.text!.isEmpty || SingletonClass.SharedInstance.userData?.updateGender == "0" {
                textField.text = arrayGender.first?.localized
            } else {
                textField.text = arrayGender.last?.localized
                pickerView.selectRow(1, inComponent: 0, animated: false)
            }
        } else if textField == txtDob {
            textField.inputView = datePickerView
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")

            dateFormatter.dateFormat = DateFomateKeys.displayDate
            if let strDate = dateFormatter.date(from: txtDob.text!) {
                datePickerView.date = strDate
            }
        } else if textField == txtHeight {
//            textField.inputView = pickerView
//            numberOfComponents = 4
//            if selectedHeightComponents.count > 2 {
//                let ft = (Int(selectedHeightComponents[0]) ?? 3) - 3
//                let inch = Int(selectedHeightComponents[1]) ?? 0
//                pickerView.selectRow(ft, inComponent: 0, animated: false)
//                pickerView.selectRow(inch, inComponent: 2, animated: false)
//            }
            let height = textField.text?.replacingOccurrences(of: " cm".localized, with: "")
            txtHeight.text = height
        } else if textField == txtWeight {
            let weight = textField.text?.replacingOccurrences(of: " kg".localized, with: "")
            txtWeight.text = weight
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtDob  {
           self.handleDatePicker(sender: datePickerView)
            
        } else if textField == txtHeight {
//            if let height = txtHeight.text {
//                let feetIndex = pickerView.selectedRow(inComponent: 0)
//                let inchIndex = pickerView.selectedRow(inComponent: 2)
//                txtHeight.text = "\(feetList[feetIndex])'\(inchList[inchIndex])''"
//                if !height.isBlank {
//                    print(height.components(separatedBy: CharacterSet(charactersIn: "'")))
//                    selectedHeightComponents = height.components(separatedBy: CharacterSet(charactersIn: "'"))
//                }
//            }
            if let height = txtHeight.text {
                txtHeight.text = height + " cm".localized
            }
        } else if textField == txtWeight {
            if let weight = txtWeight.text {
                txtWeight.text = weight + " kg".localized
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtWeight {
            if textField.text?.count == 0 && string == "0" {
                return false
            }
        } else if textField == txtHeight {
            if textField.text?.count == 0 && string == "0" {
                return false
            }
        }
        return true
    }
}

// ----------------------------------------------------
//MARK:- --------- PickerView Methods ---------
// ----------------------------------------------------

extension EditProfileViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if numberOfComponents == 1 {
             return arrayGender.count
        } else {
            if component == 0 {
                return feetList.count
            }else if component == 2 {
                return inchList.count
            }else {
                return 1
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if numberOfComponents == 1 {
            return arrayGender[row].localized
        } else {
            if component == 0 {
                return "\(feetList[row])"
            }else if component == 1 {
                return "ft"
            }else if component == 2 {
                return "\(inchList[row])"
            }else {
                return "in"
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if numberOfComponents == 1 {
            txtGender.text = arrayGender[row].localized
            selectedGender = arrayGender[row]
        } else {
            let feetIndex = pickerView.selectedRow(inComponent: 0)
            let inchIndex = pickerView.selectedRow(inComponent: 2)
            txtHeight.text = "\(feetList[feetIndex])'\(inchList[inchIndex])''"
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- ImagePicker Delegate Methods ---------
// ----------------------------------------------------

extension EditProfileViewController :  ImagePickerDelegate {
    
    func didSelect(image: UIImage?, SelectedTag: Int) {
        
        if(image == nil && SelectedTag == 101){
            self.imgProfilePicture.image = UIImage(named: "m-logo")//UIImage.init(named: "imgPetPlaceholder")
            self.selectedImage = nil
            isRemovePhoto = true
            
        } else if image != nil {
            self.imgProfilePicture.image = image
            self.selectedImage = self.imgProfilePicture.image
        }
    }
}

// ----------------------------------------------------
// MARK: - --------- Webservice Methods ---------
// ----------------------------------------------------

extension EditProfileViewController {
    
    func webserviceCallForEditProfile(editProfileDic: EditProfileModel){
        
        UtilityClass.showHUD()
        
        UserWebserviceSubclass.editProfile(editProfileModel: editProfileDic, image: selectedImage){ (json, status, res) in
            
            UtilityClass.hideHUD()
            
            if status{
                 let loginResponseModel = LoginResponseModel(fromJson: json)
                do{
                    try UserDefaults.standard.set(object: loginResponseModel.data, forKey: UserDefaultKeys.kUserProfile)
                }catch{
                    UtilityClass.showAlert(Message: error.localizedDescription)
                }
                self.getUserData()
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
                UtilityClass.showAlertWithCompletion(title: "", Message: msg, ButtonTitle: "OK", Completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
            else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
