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
    //MARK:- --------- Lifecycle Methods ---------
    // ----------------------------------------------------
    
    private var imagePicker : ImagePickerClass!
    let pickerView = UIPickerView()
    let datePickerView = UIDatePicker()
    var selectedImage : UIImage?
    
    var arrayGender = ["Male","Female"]
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.updateMylocation()
        setupProfileData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(isHidden: false, title: "Edit Profile", hidesBackButton: false)
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
        dateFormatter.dateFormat = DateFomateKeys.display
        txtDob.text = dateFormatter.string(from: sender.date)
    }
    
    func setupProfileData(){
        
        if let userData = SingletonClass.SharedInstance.userData {
            txtNickName.text = userData.nickName
            txtMobile.text = userData.phone
            txtEmail.text = userData.email
            txtGender.text = userData.gender
            txtHeight.text = userData.height
            txtWeight.text = userData.weight
            if userData.dateOfBirth != "0000-00-00" {
                if let dob = UtilityClass.changeDateFormateFrom(dateString: userData.dateOfBirth, fromFormat: DateFomateKeys.api, withFormat: DateFomateKeys.display) {
                     txtDob.text = dob
                }
            }
        }
    
        if let url = URL(string: SingletonClass.SharedInstance.userData?.profilePicture ?? "") {
            imgProfilePicture.kf.indicatorType = .activity
            imgProfilePicture.kf.setImage(
                with: url,
                placeholder: UIImage(named: "user"),
                options: [
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
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
            editModel.Gender = txtGender.text!
            editModel.Height = txtHeight.text ?? ""
            editModel.Weight = txtWeight.text ?? ""
            if let dob = UtilityClass.changeDateFormateFrom(dateString: txtDob.text ?? "", fromFormat: DateFomateKeys.display, withFormat: DateFomateKeys.api) {
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
//            if let token = UserDefaults.standard.object(forKey: UserDefaultKeys.kDeviceToken) as? String{
//                editModel.DeviceToken =  token
//            }
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
// MARK: - Webservice Methods
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
                UtilityClass.showAlertWithCompletion(title: "", Message: json["message"].stringValue, ButtonTitle: "OK", Completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
            else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}

extension EditProfileViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtGender {
            textField.inputView = pickerView
            if textField.text!.isEmpty || textField.text == arrayGender.first {
                textField.text = arrayGender.first
            } else {
                textField.text = arrayGender.last
                pickerView.selectRow(1, inComponent: 0, animated: false)
            }
        } else if textField == txtDob {
            textField.inputView = datePickerView
        }
    }
}

extension EditProfileViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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

extension EditProfileViewController :  ImagePickerDelegate {
    
    func didSelect(image: UIImage?, SelectedTag: Int) {
        
        if image != nil{
            self.imgProfilePicture.image = image
            self.selectedImage = image
        }
    }
}
