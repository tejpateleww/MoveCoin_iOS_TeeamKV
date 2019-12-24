//
//  CardListViewController.swift
//  Movecoins
//
//  Created by eww090 on 14/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

protocol CardDelegate {
    func setCardDetails(value: PlaceOrder)
}


class CardListViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var lblAddPayment: UILabel!
    
    @IBOutlet weak var txtCardHolder: ThemeTextfield!
    @IBOutlet weak var txtCardNumber: ThemeTextfield!
    @IBOutlet weak var txtExpDate: ThemeTextfield!
    @IBOutlet weak var txtCVV: ThemeTextfield!
    
    // ----------------------------------------------------
    // MARK: ----------  Variables ---------
    // ----------------------------------------------------
    
    lazy var cardArray : [Card] = []
    let expiryDatePicker = MonthYearPickerView()
    var delegate:CardDelegate?
    
    // ----------------------------------------------------
    // MARK: ----------  ViewController Lifecycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        self.setupFont()
        navigationBarSetUp()
        self.title =  "Card Details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
  
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func initialSetup(){
        txtCardNumber.delegate = self
        txtExpDate.delegate = self
        txtCVV.delegate = self
        
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year % 100)
            self.txtExpDate.text = string
        }
    }
    
    func setupFont(){
        lblAddPayment.font = UIFont.bold(ofSize: 20)
        txtExpDate.font = UIFont.regular(ofSize: 17)
        txtCardNumber.font = UIFont.regular(ofSize: 17)
        txtCardHolder.font = UIFont.regular(ofSize: 17)
        txtCVV.font = UIFont.regular(ofSize: 17)
    }
    
    func validate() {
        do {
            let cardHolder = try txtCardHolder.validatedText(validationType: ValidatorType.cardHolder)
            let cardNumber = try txtCardNumber.validatedText(validationType: ValidatorType.cardNumber)
            let expDate = try txtExpDate.validatedText(validationType: ValidatorType.expDate)
            let cvv = try txtCVV.validatedText(validationType: ValidatorType.cvv)
            
            let requestModel = PlaceOrder()
            requestModel.card_holder_name = cardHolder
            requestModel.card_no = cardNumber
            requestModel.card_expiry_date = expDate
            requestModel.card_cvv_no = cvv
            
            delegate?.setCardDetails(value: requestModel)
            self.navigationController?.popViewController(animated: true)

        } catch(let error) {
            UtilityClass.showAlert(Message: (error as! ValidationError).message)
        }
    }
    
    // ----------------------------------------------------
    //MARK:- --------- IBAction Methods ---------
    // ----------------------------------------------------

    @IBAction func btnAddCardTapped(_ sender: Any) {
        self.validate()
    }
}

// ----------------------------------------------------
//MARK:- --------- CardNumber Formate Methods ---------
// ----------------------------------------------------

extension CardListViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtExpDate{
            textField.inputView = expiryDatePicker
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            return true
        }

        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }

        if textField == txtCardNumber {
            
            if ((range.location >= 19) || (textField.text?.count ?? 0 >= 19) ){
                return false
            }
            textField.text = currentText.grouping(every: 4, with: " ")
            return false
 
        } else if textField == txtCVV {
            if (range.location >= 4) {
                return false
            }
        }
        return true
    }
}
