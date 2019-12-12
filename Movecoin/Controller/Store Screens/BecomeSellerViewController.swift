//
//  BecomeSellerViewController.swift
//  Movecoin
//
//  Created by eww090 on 12/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class BecomeSellerViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtBusinessName: TextFieldFont!
    @IBOutlet weak var txtShopName: TextFieldFont!
    @IBOutlet weak var txtPhoneNumber: TextFieldFont!
    @IBOutlet weak var txtEmail: TextFieldFont!
    @IBOutlet weak var txtShopPlace: TextFieldFont!
    @IBOutlet weak var txtProductType: TextFieldFont!
    
    // ----------------------------------------------------
    //MARK:- --------- Variables ---------
    // ----------------------------------------------------
    
    lazy var typeOfProducts = [Category]()
    lazy var pickerView = UIPickerView()
    var selectedCategory : Category?
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationBarSetUp()
    }
    
    // ----------------------------------------------------
    //MARK:- --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setupView(){
        txtBusinessName.delegate = self
        txtShopName.delegate = self
        txtEmail.delegate = self
        txtPhoneNumber.delegate = self
        txtShopPlace.delegate = self
        txtProductType.delegate = self
        
        pickerView.delegate = self
        
        lblTitle.font = UIFont.regular(ofSize: 21)
        
        if let types = SingletonClass.SharedInstance.productType  {
            typeOfProducts = types
        }
    }
    
    func validate() {
        do {
           
            let businessName = try txtBusinessName.validatedText(validationType: ValidatorType.requiredField(field: (txtBusinessName.placeholder?.lowercased())!))
            let shopName = try txtShopName.validatedText(validationType: ValidatorType.requiredField(field: (txtShopName.placeholder?.lowercased())!))
            let phoneNumber = try txtPhoneNumber.validatedText(validationType: ValidatorType.mobileNumber)
            let email = try txtEmail.validatedText(validationType: ValidatorType.email)
            let shopPlace = try txtShopPlace.validatedText(validationType: ValidatorType.requiredField(field: (txtShopPlace.placeholder?.lowercased())!))
            if txtProductType.text!.trimmingCharacters(in: .whitespacesAndNewlines).isBlank {
                UtilityClass.showAlert(Message: "Please select product type")
                return
            }
            guard let id = SingletonClass.SharedInstance.userData?.iD else {
                return
            }
            let sellerModel = BecomeSellerModel()
            sellerModel.UserID = id
            sellerModel.BusinessName = businessName
            sellerModel.ShopName = shopName
            sellerModel.Phone = phoneNumber
            sellerModel.Email = email
            sellerModel.ShopAddress = shopPlace
            sellerModel.CategoryId = selectedCategory?.iD ?? ""

            webserviceCallForSeller(sellerModel: sellerModel)
        } catch(let error) {
            UtilityClass.showAlert(Message: (error as! ValidationError).message)
        }
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnRegisterTapped(_ sender: Any) {
        self.validate()
    }
}

// ----------------------------------------------------
//MARK:- --------- TextField Delegate Methods ---------
// ----------------------------------------------------

extension BecomeSellerViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtProductType {
            textField.inputView = pickerView
            if textField.text!.isEmpty {
                textField.text = typeOfProducts.first?.categoryName
                selectedCategory = typeOfProducts.first
            }
        }
    }
}

// ----------------------------------------------------
// MARK: - --------- Pickerview Delegate Methods ---------
// ----------------------------------------------------

extension BecomeSellerViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeOfProducts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let type = typeOfProducts[row]
        return type.categoryName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let type = typeOfProducts[row]
        selectedCategory = type
        txtProductType.text = type.categoryName
    }
}

// ----------------------------------------------------
// MARK: - --------- Webservice Methods ---------
// ----------------------------------------------------

extension BecomeSellerViewController : AlertDelegate {
    
    func webserviceCallForSeller(sellerModel: BecomeSellerModel){
        
        UtilityClass.showHUD()
       
        SellerWebserviceSubclass.becomeSeller(sellerModel: sellerModel){ (json, status, res) in
            
            UtilityClass.hideHUD()
            print(json)
           
            if status{
              
                let destination = self.storyboard?.instantiateViewController(withIdentifier: AlertViewController.className) as! AlertViewController
                destination.alertTitle = "Thank You"
                destination.alertDescription = json["message"].stringValue
                destination.delegate = self
                destination.modalPresentationStyle = .overCurrentContext
                self.present(destination, animated: true, completion: nil)
            }
            else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func okHandler() {
        self.navigationController?.popViewController(animated: true)
    }
}

