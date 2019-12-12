//
//  CardListViewController.swift
//  Movecoins
//
//  Created by eww090 on 14/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

protocol CardDelegate {
    func setCardDetails(value: Card)
}


class CardListViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var tblCardList: UITableView!
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
        webserviceCallForCardList()
        self.title =  "Card List"
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
        tblCardList.delegate = self
        tblCardList.dataSource = self
        
        txtCardNumber.delegate = self
        txtExpDate.delegate = self
        
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
            
            let requestModel = AddCardModel()
            requestModel.Name = cardHolder
            requestModel.CardNo = cardNumber
            requestModel.Expiry = expDate
            requestModel.Cvv = cvv
            requestModel.UserID = SingletonClass.SharedInstance.userData?.iD ?? ""
            
            webserviceCallForAddCard(cardModel: requestModel)
            
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
//MARK:- --------- Tableview Delegate Methods ---------
// ----------------------------------------------------

extension CardListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.className) as! CardTableViewCell
        cell.selectionStyle = .none
        cell.cardDetail = cardArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.setCardDetails(value: cardArray[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            UtilityClass.showAlertWithTwoButtonCompletion(title: kAppName, Message: "Are you sure you want to delete the card?", ButtonTitle1: "OK", ButtonTitle2: "Cancel") { (data) in
                if data == 0 {
                    let data = self.cardArray[indexPath.row]
                    self.webserviceCallForDeleteCard(cardID: data.id)
                }
            }
        }
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
        
        if string == ""{
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
            if (range.location >= 3) {
                return false
            }
        }
        return true
    }
}

// ----------------------------------------------------
// MARK: - --------- Webservice Methods ---------
// ----------------------------------------------------

extension CardListViewController {
    
    func webserviceCallForAddCard(cardModel: AddCardModel){
        
        UtilityClass.showHUD()
        
        UserWebserviceSubclass.addCard(addCardModel: cardModel){ (json, status, res) in
            
            UtilityClass.hideHUD()
            
            if status{
                let cardResponseModel = AddCardResponseModel(fromJson: json)
                UtilityClass.showAlert(Message: cardResponseModel.message)
                self.cardArray = cardResponseModel.cards
                DispatchQueue.main.async {
                    self.tblCardList.reloadData()
                }
            }
            else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func webserviceCallForCardList(){
        
        var strParam = String()
        UtilityClass.showHUD()
                    
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
                   
        strParam = NetworkEnvironment.baseURL + ApiKey.cardList.rawValue + id
                  
        UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
           
            UtilityClass.hideHUD()
        
            if status{
                let cardResponseModel = CardListResponseModel(fromJson: json)
                self.cardArray = cardResponseModel.cards
                DispatchQueue.main.async {
                    self.tblCardList.reloadData()
                }
            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func webserviceCallForDeleteCard(cardID: String){
        
        var strParam = String()
        UtilityClass.showHUD()
                    
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
                   
        strParam = NetworkEnvironment.baseURL + ApiKey.removeCard.rawValue + id + "/\(cardID)"
                  
        UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
           
            UtilityClass.hideHUD()
        
            if status{
                let cardResponseModel = CardListResponseModel(fromJson: json)
                self.cardArray = cardResponseModel.cards
                DispatchQueue.main.async {
                    self.tblCardList.reloadData()
                }
            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
