//
//  CardListViewController.swift
//  Movecoins
//
//  Created by eww090 on 14/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

struct CardDetail {
    var name : String
    var number : String
    var image : String
}

class CardListViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var tblCardList: UITableView!
    @IBOutlet weak var lblAddPayment: UILabel!
    
    @IBOutlet weak var txtCardHolder: ThemeTextfield!
    @IBOutlet weak var txtCardNumber: ThemeTextfield!
    @IBOutlet weak var txtExpDate: ThemeTextfield!
    @IBOutlet weak var txtCVV: ThemeTextfield!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    
     var cardArray : [CardDetail] = []
    
    // ----------------------------------------------------
    // MARK: - ViewController Lifecycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        self.setupFont()
        navigationBarSetUp(isHidden: false, title: "", backroundColor: .clear, hidesBackButton: false)
        self.title =  "Card List"
        
        let card1 = CardDetail(name: "HSEB Debit Card", number: "1234 1234 1234 8745", image: "visa-card")
        let card2 = CardDetail(name: "HSEB Debit Card", number: "1234 1234 1234 8745", image: "master-card")
        let card3 = CardDetail(name: "HSEB Debit Card", number: "1234 1234 1234 8745", image: "discover-card")
        let card4 = CardDetail(name: "HSEB Debit Card", number: "1234 1234 1234 8745", image: "visa-card")
        cardArray = [card1,card2,card3,card4]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
  
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func initialSetup(){
        tblCardList.delegate = self
        tblCardList.dataSource = self
        
        txtCardNumber.delegate = self
        txtExpDate.delegate = self
        txtCVV.delegate = self
//        txtCardNumber.addTarget(self, action: #selector(reformatAsCardNumber(_:)), forControlEvents: .EditingChanged)
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
         
        } catch(let error) {
            UtilityClass.showAlert(Message: (error as! ValidationError).message)
        }
    }
    
    // ----------------------------------------------------
    //MARK:- --------- IBAction Methods ---------
    // ----------------------------------------------------

    @IBAction func btnAddCardTapped(_ sender: Any) {
//        self.validate()
    }
}

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
}

// ----------------------------------------------------
//MARK:- --------- CardNumber Formate Methods ---------
// ----------------------------------------------------

extension CardListViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(range)
        print(textField.text?.count)
        
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
            
        } else if textField == txtExpDate {
            if ((range.location >= 5) || (textField.text?.count ?? 0 >= 5) ){
                return false
            }
            textField.text = currentText.grouping(every: 2, with: "/")
            return false
        } else if textField == txtCVV {
            if (range.location >= 3) {
                return false
            }
        }

        return true
        
//        if string == ""{
//            return true
//        }
//
//        if (textField.text?.count ?? 0 >= 19) {
//            return false
//        }
//
//        if (range.location >= 19) {
//            return false
//        }
//
//        if range.length == 1 {
////            if (range.location == 5 || range.location == 10 || range.location == 15) {
//                let text = textField.text ?? ""
////                textField.text = text.substring(to: text.index(before: text.endIndex))
//                let index = text.index(before: text.endIndex)
//                textField.text = String(text.suffix(from: index))
////            }
//            return true
//        }
//
//        if (range.location == 4 || range.location == 9 || range.location == 14) {
//            textField.text = String(format: "%@ ", textField.text ?? "")
//        }
//
//        return true
    }
}

extension String {
    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
        let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
        return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
            }.joined().dropFirst())
    }
}
