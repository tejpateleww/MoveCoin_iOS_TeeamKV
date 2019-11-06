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
    
    var arrayGender = ["Male","Female"]
    let pickerView = UIPickerView()
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupFont()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationBarSetUp(isHidden: true)
    }
    
    override func viewDidLayoutSubviews() {
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
    }
    
    func setupFont(){
        lblAccount.font = UIFont.regular(ofSize: 15)
        btnSignIn.titleLabel?.font = UIFont.semiBold(ofSize: 15)
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
}

extension SignupViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtGender {
            textField.inputView = pickerView
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
