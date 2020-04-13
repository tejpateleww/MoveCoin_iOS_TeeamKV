//
//  ConfirmPurchaseViewController.swift
//  Movecoin
//
//  Created by eww090 on 10/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class ConfirmPurchaseViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    
    //    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblAvailableBalance: UILabel!
    @IBOutlet weak var lblPurchase: UILabel!
    @IBOutlet weak var lblTitleAvailableBalance: UILabel!
    @IBOutlet var lblPrice: [UILabel]!
    @IBOutlet weak var lblTitleProductPrice: LocalizLabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblTitleDiscount: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTitleDelivery: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblTitleTotal: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var viewCardSelect: UIView!
    @IBOutlet weak var productPriceStack: UIStackView!
    @IBOutlet weak var discountStack: UIStackView!
    @IBOutlet weak var deliveryStack: UIStackView!
    @IBOutlet weak var totalStack: UIStackView!
    
    @IBOutlet weak var txtName: TextFieldFont!
    @IBOutlet weak var txtNumber: TextFieldFont!
    @IBOutlet weak var txtEmail: TextFieldFont!
    @IBOutlet weak var txtAddress1: TextFieldFont!
    @IBOutlet weak var txtAddress2: TextFieldFont!
    @IBOutlet weak var txtCountry: TextFieldFont!
    @IBOutlet weak var txtState: TextFieldFont!
    @IBOutlet weak var txtCity: TextFieldFont!
    @IBOutlet weak var txtZipCode: TextFieldFont!
    
    @IBOutlet weak var imgCardIcon: UIImageView!
    @IBOutlet weak var txtCard: TextFieldFont!
    @IBOutlet weak var txtMoveCoins: TextFieldFont!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var product : ProductDetails!
    let userData = SingletonClass.SharedInstance.userData
    lazy var orderDetails = PlaceOrder()
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        localizeUI(parentView: self.viewParent)
        self.setupFont()
        self.setupView()
        setupProductData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationBarSetUp()
        self.title =  "Confirm Purchase".localized
        let arrowImg = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? (UIImage(named: "arrow-right")?.imageFlippedForRightToLeftLayoutDirection()) : (UIImage(named: "arrow-right"))
        btnArrow.setImage(arrowImg, for: .normal)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setupFont(){
        for lbl in lblPrice {
            lbl.font = UIFont.semiBold(ofSize: 19)
        }
        switch UIDevice.current.screenType {
        case .iPhones_5_5s_5c_SE:
            lblProductName.font = UIFont.semiBold(ofSize: 20)
        default:
            lblProductName.font = UIFont.semiBold(ofSize: 24)
        }
        
        //        lblTotal.font = UIFont.semiBold(ofSize: 19)
        lblAddress.font = UIFont.semiBold(ofSize: 23)
        lblPurchase.font = UIFont.semiBold(ofSize: 19)
        lblAvailableBalance.font = UIFont.bold(ofSize: 18)
        lblTitleAvailableBalance.font = UIFont.semiBold(ofSize: 17)
        lblTitleProductPrice.font = UIFont.semiBold(ofSize: 17)
        lblProductPrice.font = UIFont.semiBold(ofSize: 17)
        lblTitleDiscount.font = UIFont.semiBold(ofSize: 17)
        lblDiscount.font = UIFont.semiBold(ofSize: 17)
        lblTitleDelivery.font = UIFont.semiBold(ofSize: 17)
        lblDelivery.font = UIFont.semiBold(ofSize: 17)
        lblTitleTotal.font = UIFont.semiBold(ofSize: 17)
        lblTotal.font = UIFont.semiBold(ofSize: 17)
    }
    
    func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.cardViewTapped(_:)))
        viewCardSelect.addGestureRecognizer(tap)
        viewCardSelect.isUserInteractionEnabled = true
        imgCardIcon.isHidden = true
        txtMoveCoins.delegate = self
        lblTitleAvailableBalance.text = "Now Available Balance".localized
        
        txtName.placeHolderColor = TransparentColor
        txtNumber.placeHolderColor = TransparentColor
        txtEmail.placeHolderColor = TransparentColor
        txtAddress1.placeHolderColor = TransparentColor
        txtAddress2.placeHolderColor = TransparentColor
        txtCountry.placeHolderColor = TransparentColor
        txtState.placeHolderColor = TransparentColor
        txtCity.placeHolderColor = TransparentColor
        txtZipCode.placeHolderColor = TransparentColor
        txtCard.placeHolderColor = TransparentColor
        
//        lblTitleProductPrice.text = "Product Price".localized

        lblPurchase.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .left : .right
        lblProductPrice.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .left : .right
        lblDiscount.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .left : .right
        lblDelivery.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .left : .right
        lblTotal.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .left : .right
    }
    
    func setupProductData() {
        if let product = product {
            lblProductName.text = product.name
            lblPrice = lblPrice.compactMap{$0.text = product.coins} as? [UILabel]
            // For Image
            //            let productsURL = NetworkEnvironment.baseImageURL + product.productImage
            if let url = URL(string: product.productImage) {
                self.imgProduct.kf.indicatorType = .activity
                self.imgProduct.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))
            }
            lblProductPrice.text = product.price + " \(currency.localized)"
            lblDiscount.text = product.discountedPrice + " \(currency.localized)"
            lblDelivery.text = product.deliveryCharge + " \(currency.localized)"
            lblTotal.text = product.totalPrice + " \(currency.localized)"
        }
       
        if let user = userData {
            lblAvailableBalance.text = user.coins ?? "0"
        }
    }
    
    @objc func cardViewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        let controller = self.storyboard?.instantiateViewController(withIdentifier: CardListViewController.className) as! CardListViewController
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func validate() {
        do {
            let name = try txtName.validatedText(validationType: ValidatorType.fullname)
            let number = try txtNumber.validatedText(validationType: ValidatorType.mobileNumber)
            let email = try txtEmail.validatedText(validationType: ValidatorType.email)
            let address1 = try txtAddress1.validatedText(validationType: ValidatorType.requiredField(field: txtAddress1.placeholder!))
            let address2 = try txtAddress2.validatedText(validationType: ValidatorType.requiredField(field: txtAddress2.placeholder!))
            let country = try txtCountry.validatedText(validationType: ValidatorType.requiredField(field: txtCountry.placeholder!))
            let state = try txtState.validatedText(validationType: ValidatorType.requiredField(field: txtState.placeholder!))
            let city = try txtCity.validatedText(validationType: ValidatorType.requiredField(field: txtCity.placeholder!))
            let zipcode = try txtZipCode.validatedText(validationType: ValidatorType.requiredField(field: txtZipCode.placeholder!))
            //                let moveCoins = try txtMoveCoins.validatedText(validationType: ValidatorType.requiredField(field: txtMoveCoins.placeholder!))
            if txtCard.text!.isBlank {
                UtilityClass.showAlert(Message: "Please enter card details")
                return
            }
            orderDetails.name = name
            orderDetails.phone = number
            orderDetails.email = email
            orderDetails.address1 = address1
            orderDetails.address2 = address2
            orderDetails.country = country
            orderDetails.state = state
            orderDetails.city = city
            orderDetails.zip = zipcode
            orderDetails.product_id = product.iD
            orderDetails.user_id = SingletonClass.SharedInstance.userData?.iD ?? ""
            //                orderDetails.user_redeemed_coins = moveCoins
            
            webserviceCallForPlaceOrder(model: orderDetails)
            
        } catch(let error) {
            UtilityClass.showAlert(Message: (error as! ValidationError).message)
        }
    }
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnPurchaseTapped(_ sender: Any) {
       
        var availableCoins = 0
        var productCoins = 0

        if let coins = userData?.coins {
            availableCoins = Int(coins) ?? 0
        }
        
        if let coins = product.coins {
            productCoins = Int(coins) ?? 0
        }
        
        if availableCoins < productCoins {
            var msg = ""
            if let discount = product.discount, discount != "0" {
                msg = "Your current balance is too low to purchase ".localized + discount + " % off " + product.name! + ". Don't want to wait? invite Friends and Family to earn faster!".localized
            } else {
                msg = "Your current balance is too low to purchase ".localized + product.name! + ". Don't want to wait? invite Friends and Family to earn faster!".localized
            }
            let destination = self.storyboard?.instantiateViewController(withIdentifier: AlertViewController.className) as! AlertViewController
            destination.alertTitle = "Insufficient Balance".localized
            destination.alertDescription = msg
            destination.modalPresentationStyle = .overCurrentContext
            self.present(destination, animated: true, completion: nil)
        }else{
            print("Purchase")
            validate()
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- TextField Delegate Methods ---------
// ----------------------------------------------------

extension ConfirmPurchaseViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtMoveCoins {
//            viewPayableAmount.isHidden = true
            if txtMoveCoins.text != "" {
                var enteredCoins = 0.0
                var productCoins = 0.0
                var coinsRequired = 0.0
                
                if let coins = SingletonClass.SharedInstance.coinsDiscountRelation?.coins {
                    coinsRequired = Double(coins)!
                }
                if let coins = product.coins {
                    productCoins = Double(coins)!
                }
                if let coins = txtMoveCoins.text {
                    enteredCoins = Double(coins)!
                }
                if enteredCoins < coinsRequired {
                    UtilityClass.showAlert(Message: "You need to spend atleast ".localized + "\(Int(coinsRequired)) MoveCoins")
                    txtMoveCoins.text = ""
                } else if enteredCoins > productCoins {
                    UtilityClass.showAlert(Message: "You can not spend more than ".localized + "\(Int(productCoins)) MoveCoins")
                    txtMoveCoins.text = ""
                } else{
                    var finalPrice = 0.0
                    var discount = 0.0
                    var productPrice = 0.0
                    var percentage = 0.0
                    
                    if let coins = product.totalPrice {
                        productPrice = Double(coins)!
                    }
                    if let ratioStr = SingletonClass.SharedInstance.coinsDiscountRelation?.percentageDiscount{
                        let ratio = Double(ratioStr)!
                        percentage = (((enteredCoins * ratio) / coinsRequired) / 100)
                    }
                    discount = productPrice * percentage
                    finalPrice = productPrice - discount
                    lblTotal.text = String(finalPrice)
//                    viewPayableAmount.isHidden = false
                }
            }
        }
    }
}

// ----------------------------------------------------
// MARK: - --------- CardDelegate Methods ---------
// ----------------------------------------------------

extension ConfirmPurchaseViewController : CardDelegate {
    
    func setCardDetails(value: PlaceOrder) {
        orderDetails = value
        let cardNo = String("XXXX XXXX XXXX \(value.card_no.suffix(4))")
        txtCard.text = cardNo
    }
}

// ----------------------------------------------------
// MARK: - --------- Webservice Methods ---------
// ----------------------------------------------------

extension ConfirmPurchaseViewController  {
    
    func webserviceCallForPlaceOrder(model: PlaceOrder){
        
        UtilityClass.showHUD()
        
        OrderWebserviceSubclass.placeOrder(orderModel: model){ (json, status, res) in
            
            UtilityClass.hideHUD()
        
            if status{
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
    
    func okHandler() {
        self.navigationController?.popViewController(animated: true)
    }
}
