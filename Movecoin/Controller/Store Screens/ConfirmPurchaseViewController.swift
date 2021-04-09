//
//  ConfirmPurchaseViewController.swift
//  Movecoin
//
//  Created by eww090 on 10/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import PassKit
import SwiftyJSON
import FirebaseAnalytics
class ConfirmPurchaseViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var btnArrow: UIButton?
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
    @IBOutlet weak var lblTaxTitle: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblTitleDiscount: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTitleDelivery: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblTitleTotal: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var viewCardSelect: UIView?
    @IBOutlet weak var productPriceStack: UIStackView!
    @IBOutlet weak var discountStack: UIStackView!
    @IBOutlet weak var deliveryStack: UIStackView!
    @IBOutlet weak var totalStack: UIStackView!
    
    let expiryDatePicker = MonthYearPickerView()
    
    var closure : ((String) -> Void)?
    
    @IBOutlet weak var txtName: TextFieldFont!
    @IBOutlet weak var txtNumber: TextFieldFont!
    @IBOutlet weak var txtEmail: TextFieldFont!
    @IBOutlet weak var txtAddress1: TextFieldFont!
    //    @IBOutlet weak var txtAddress2: TextFieldFont?
    //    @IBOutlet weak var txtCountry: TextFieldFont!
    @IBOutlet weak var txtState: TextFieldFont!
    @IBOutlet weak var txtCity: TextFieldFont!
    //    @IBOutlet weak var txtZipCode: TextFieldFont!
    
    @IBOutlet weak var imgCardIcon: UIImageView?
    @IBOutlet weak var txtCard: TextFieldFont?
    @IBOutlet weak var txtMoveCoins: TextFieldFont!
    
    @IBOutlet weak var txtCardHolder: ThemeTextfield!
    @IBOutlet weak var txtCardNumber: ThemeTextfield!
    @IBOutlet weak var txtExpDate: ThemeTextfield!
    @IBOutlet weak var txtCVV: ThemeTextfield!
    
    
    // ----------------------------------------------------
    // MARK: - --------- Apple Pay Variables ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var viewApplePay: UIView?
    var applePayButton = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
    var merchantId = "3000000151" //"3000000151"
    var appIdentifier = "merchant.\(Bundle.main.bundleIdentifier ?? "")"
    var merchantURL = "https://www.movecoins.net/admin/pg/apple/"
    var countryCode = "SA"
    var supportedNetworks: [PKPaymentNetwork] = [.visa, .masterCard, .discover, .amex, .mada]
    var request : PKPaymentRequest?
    var applePayPayment: PKPayment?
    
    
    
    // MARK: - Properties
    var transaction: Transaction = Transaction()
    
    // the object used to communicate with the merchant's api
    var merchantAPI: MerchantAPI!
    // the ojbect used to communicate with the gateway
    var gateway: Gateway!
    
    
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
     
        self.setupFont()
        self.setupView()
        self.setupTextfield()
        setupProductData()
        Analytics.logEvent("ProductPurchaseScreen", parameters: nil)

//        txtName.text = "Rahul"
//        txtNumber.text = "1102298338"
//        txtEmail.text = "asdas@gdd.com"
//        txtAddress1.text = "asdasd"
//        txtState.text = "asdasd"
//        txtCity.text = "asdad"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationBarSetUp()
        self.title =  "Confirm Purchase".localized
        let arrowImg = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? (UIImage(named: "arrow-right")?.imageFlippedForRightToLeftLayoutDirection()) : (UIImage(named: "arrow-right"))
        btnArrow?.setImage(arrowImg, for: .normal)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    
    func setupTextfield()
    {
        txtNumber.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtCity.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtState.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

        let text = textField.text ?? ""

        let trimmedText = text.replacingOccurrences(of: " ", with: "")

        textField.text = trimmedText
    }
    
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
        lblPurchase.font = UIFont.semiBold(ofSize: 23)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applePayButton.frame = viewApplePay?.bounds ?? CGRect.zero
        applePayButton.layer.cornerRadius = applePayButton.frame.height/2
        applePayButton.layer.masksToBounds = true
        applePayButton.titleLabel?.font = UIFont(name: FontBook.SemiBold.rawValue, size: 20.0)
    }
    
    func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.cardViewTapped(_:)))
        viewCardSelect?.addGestureRecognizer(tap)
        viewCardSelect?.isUserInteractionEnabled = true
        imgCardIcon?.isHidden = true
        txtMoveCoins.delegate = self
        lblTitleAvailableBalance.text = "Now Available Balance".localized
        
        viewApplePay?.addSubview(applePayButton)
        applePayButton.addTarget(self, action: #selector(setupPaymentForApplePay), for: .touchUpInside)
        
        
        txtName.placeHolderColor = TransparentColor
        txtNumber.placeHolderColor = TransparentColor
        txtEmail.placeHolderColor = TransparentColor
        txtAddress1.placeHolderColor = TransparentColor
        //        txtAddress2.placeHolderColor = TransparentColor
        //        txtCountry.placeHolderColor = TransparentColor
        txtState.placeHolderColor = TransparentColor
        txtCity.placeHolderColor = TransparentColor
        //        txtZipCode.placeHolderColor = TransparentColor
        txtCard?.placeHolderColor = TransparentColor
        
        //        lblTitleProductPrice.text = "Product Price".localized
        
        lblPurchase.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .left : .right
        lblProductPrice.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .left : .right
        lblDiscount.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .left : .right
        lblDelivery.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .left : .right
        lblTotal.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .left : .right
        
        txtCardNumber.delegate = self
        txtExpDate.delegate = self
        txtCVV.delegate = self
        
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year % 100)
            self.txtExpDate.text = string
        }
        txtExpDate.inputView = expiryDatePicker
        
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
    
    func validate(isFromApplePay : Bool = false) {
        do {
            let name = try txtName.validatedText(validationType: ValidatorType.fullname)
            let number = try txtNumber.validatedText(validationType: ValidatorType.mobileNumber)
            let email = try txtEmail.validatedText(validationType: ValidatorType.email)
            let address1 = try txtAddress1.validatedText(validationType: ValidatorType.requiredField(field: txtAddress1.placeholder!))
            //            let address2 = try txtAddress2.validatedText(validationType: ValidatorType.requiredField(field: txtAddress2.placeholder!))
            //            let country = try txtCountry.validatedText(validationType: ValidatorType.requiredField(field: txtCountry.placeholder!))
            let city = try txtCity.validatedText(validationType: ValidatorType.requiredField(field: txtCity.placeholder!))
            let state = try txtState.validatedText(validationType: ValidatorType.requiredField(field: txtState.placeholder!))
            //            let zipcode = try txtZipCode.validatedText(validationType: ValidatorType.requiredField(field: txtZipCode.placeholder!))
            //                let moveCoins = try txtMoveCoins.validatedText(validationType: ValidatorType.requiredField(field: txtMoveCoins.placeholder!))
            //            if txtCard?.text!.isBlank ?? false {
            //                UtilityClass.showAlert(Message: "Please enter card details")
            //                return
            //            }
            
            if(!isFromApplePay)
            {
                let cardHolder = try txtCardHolder.validatedText(validationType: ValidatorType.cardHolder)
                let cardNumber = try txtCardNumber.validatedText(validationType: ValidatorType.cardNumber)
                let expDate = try txtExpDate.validatedText(validationType: ValidatorType.expDate)
                let cvv = try txtCVV.validatedText(validationType: ValidatorType.cvv)
                
                orderDetails.card_holder_name = cardHolder
                orderDetails.card_no = cardNumber
                orderDetails.card_expiry_date = expDate
                orderDetails.card_cvv_no = cvv
                orderDetails.payment_type = "card"
            }
            else
            {
                orderDetails.payment_type = "apple"
                
            }
            
            orderDetails.name = name
            orderDetails.phone = number
            orderDetails.email = email
            orderDetails.address1 = address1
            //                        orderDetails.address2 = "address2"
            //            orderDetails.country = "India"
            orderDetails.state = state
            orderDetails.city = city
            //            orderDetails.zip = "123456"
            orderDetails.product_id = product.iD
            orderDetails.user_id = SingletonClass.SharedInstance.userData?.iD ?? ""
            //                orderDetails.user_redeemed_coins = moveCoins
            
            if(isFromApplePay)
            {
                configure(merchantId: merchantId, region: .asiaPacific, merchantServiceURL: URL(string: merchantURL) ?? URL(string: "")!, applePayMerchantIdentifier: appIdentifier)
                createSession()
            }
            else
            {
                webserviceCallForPlaceOrder(model: orderDetails)
            }
            
        } catch(let error) {
            UtilityClass.showAlert(Message: (error as! ValidationError).message.localized)
        }
    }
    
    func validateCoins() -> Bool
    {
        
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
            return false
        }
        else
        {
            return true
        }
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnPurchaseTapped(_ sender: Any) {
        if validateCoins() {
            print("Purchase")
            validate()
        }
    }
    
    func btnApplePayPurchaseTapped() {
        
        guard let request = self.request, let apvc = PKPaymentAuthorizationViewController(paymentRequest: request) else { return }
        apvc.delegate = self
        DispatchQueue.main.async {
                self.present(apvc, animated: true, completion: nil)
        }
    }
    
    @IBAction func setupPaymentForApplePay(_ sender: UIButton){
         if validateCoins() {
            print("Purchase")
            self.validate(isFromApplePay: true)
        }
    }
    
    /// Called to configure the view controller with the gateway and merchant service information.
    func configure(merchantId: String, region: GatewayRegion, merchantServiceURL: URL, applePayMerchantIdentifier: String?) {
        gateway = Gateway(region: region, merchantId: merchantId)
        merchantAPI = MerchantAPI(url: merchantServiceURL)
        transaction.applePayMerchantIdentifier = applePayMerchantIdentifier
    }
    
    func createSession() {
        // update the UI
        UtilityClass.showHUD()
        
        //        merchantAPI.createSession { (result) in
        //            DispatchQueue.main.async {
        //                // stop the activity indictor
        //                UtilityClass.hideHUD()
        //                guard case .success(let response) = result,
        //                    "SUCCESS" == response[at: "gatewayResponse.result"] as? String,
        //                    let session = response[at: "gatewayResponse.session.id"] as? String,
        //                    let apiVersion = response[at: "apiVersion"] as? String else {
        //                        // if anything was missing, flag the step as having errored
        //                        self.stepErrored(message: "Error Creating Session")
        //                        return
        //                }
        
        OrderWebserviceSubclass.getSessionID(strURL: "https://movecoins.net/admin/api/order/generate_session") { (json, status, response) in
            UtilityClass.hideHUD()
            if(status)
            {
                self.transaction.session = GatewaySession(id: json["session"].string ?? "", apiVersion: json["version"].string ?? "")
                self.collectCardInfo()
            }
            
        }
        
        // The session was created successfully
        //                self.stepCo//mpleted()
        //            }
        //        }
    }
    
    func collectCardInfo()
    {
        //        let payableAmount = JSON(product.discountedPrice ?? 0).floatValue + JSON(product.deliveryCharge ?? 0).floatValue
        let paymentItem = PKPaymentSummaryItem.init(label: "MoveCoins", amount: NSDecimalNumber(value: Float(product.totalPrice) ?? 0), type: .final)
        transaction.amount = NSDecimalNumber(value: Float(product.totalPrice) ?? 0)
        transaction.amountString = product.totalPrice ?? "0"
        transaction.amountFormatted = "\(transaction.currency) \(product.totalPrice ?? "0")"
        if PKPaymentAuthorizationViewController.canMakePayments() {
            request = PKPaymentRequest()
            request?.paymentSummaryItems = [paymentItem]
            request?.merchantIdentifier = appIdentifier
            request?.countryCode = countryCode
            request?.currencyCode = currency
            request?.supportedNetworks = supportedNetworks
            request?.merchantCapabilities = [.capabilityCredit, .capabilityDebit, .capability3DS]
            self.btnApplePayPurchaseTapped()
        } else {
            
            UtilityClass.showAlert(Message: "Unable to make Apple Pay transaction".localized)
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- TextField Delegate Methods ---------
// ----------------------------------------------------

extension ConfirmPurchaseViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == txtExpDate && txtExpDate.text?.count == 0 {
            let string = String(format: "%02d/%d", expiryDatePicker.month, (expiryDatePicker.year) % 100)
            self.txtExpDate.text = string
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
                    UtilityClass.showAlert(Message: "You need to spend atleast ".localized + "\(Int(coinsRequired)) \(kAppName.localized)")
                    txtMoveCoins.text = ""
                } else if enteredCoins > productCoins {
                    UtilityClass.showAlert(Message: "You can not spend more than ".localized + "\(Int(productCoins)) \(kAppName.localized)")
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
        txtCard?.text = cardNo
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
            
            var dict = [String:Any]()
            dict["product_id"] = model.product_id
            dict["user_id"] = model.user_id
            dict["name"] = model.name
            dict["email"] = model.email
            dict["payment_type"] = model.payment_type
            dict["transaction_id"] = model.transaction_id
            Analytics.logEvent("purchase", parameters: dict)
            
            if status{
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
                
                if (!(json["html"].string?.isEmpty ?? true))
                {
                    self.begin3DSAuth(simple: json["html"].string ?? "")
                }
                else
                {
                    self.webserviceForUserDetails()
                    self.closure?("product purchased")
                    UtilityClass.showAlertWithCompletion(title: "", Message: msg, ButtonTitle: "OK".localized, Completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
            else
            {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func webserviceForUserDetails(){
        
        //        UtilityClass.showHUD()
        
        let requestModel = UserDetailModel()
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
        requestModel.UserID = id
        
        UserWebserviceSubclass.userDetails(userDetailModel: requestModel){ (json, status, res) in
            
            //            UtilityClass.hideHUD()
            
            if status {
                let responseModel = LoginResponseModel(fromJson: json)
                do{
                    try UserDefaults.standard.set(object: responseModel.data, forKey: UserDefaultKeys.kUserProfile)
                    SingletonClass.SharedInstance.userData = responseModel.data
                    //                        self.userData = responseModel.data
                    //                        self.setupHomeData()
                    //                    AppDelegateShared.notificationEnableDisable(notification: self.userData?.notification ?? "0")
                }catch{
                    UtilityClass.showAlert(Message: error.localizedDescription)
                }
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func okHandler() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ConfirmPurchaseViewController : PKPaymentAuthorizationViewControllerDelegate
{
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        applePayPayment = payment
        transaction.applePayPayment = payment
        //          self.completion?(viewModel.transaction!)
        updateWithPayerData()
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    func updateWithPayerData() {
        // update the UI
        UtilityClass.showHUD()
        guard let sessionId = transaction.session?.id, let apiVersion = transaction.session?.apiVersion else { return }
        
        // construct the Gateway Map with the desired parameters.
        var request = GatewayMap()
        request[at: "sourceOfFunds.provided.card.nameOnCard"] = transaction.nameOnCard
        request[at: "sourceOfFunds.provided.card.number"] = transaction.cardNumber
        request[at: "sourceOfFunds.provided.card.securityCode"] = transaction.cvv
        request[at: "sourceOfFunds.provided.card.expiry.month"] = transaction.expiryMM
        request[at: "sourceOfFunds.provided.card.expiry.year"] = transaction.expiryYY
        
        // if the transaction has an Apple Pay Token, populate that into the map
        if let tokenData = applePayPayment?.token.paymentData, let token = String(data: tokenData, encoding: .utf8) {
            request[at: "sourceOfFunds.provided.card.devicePayment.paymentToken"] = token
        }
        
        // execute the update
        gateway.updateSession(sessionId, apiVersion: apiVersion, payload: request, completion: updateSessionHandler(_:))
    }
    
    // Call the gateway to update the session.
    fileprivate func updateSessionHandler(_ result: GatewayResult<GatewayMap>) {
        DispatchQueue.main.async {
            //            self.updateSessionActivityIndicator.stopAnimating()
            
            guard case .success(_) = result else {
                //                self.stepErrored(message: "Error Updating Session", stepStatusImageView: self.updateSessionStatusImageView)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UtilityClass.showAlert(Message: "Error in payment".localized)
                    UtilityClass.hideHUD()
                }
                
                return
            }
            
            // mark the step as completed
            //            self.stepCompleted(stepStatusImageView: self.updateSessionStatusImageView)
            
            // check for 3DS enrollment
            self.check3dsEnrollment()
        }
    }
}

// MARK: - 4. Check 3DS Enrollment
extension ConfirmPurchaseViewController {
    // uses the gateway (throught the merchant service) to check the card to see if it is enrolled in 3D Secure
    func check3dsEnrollment() {
        // if the transaction is an Apple Pay Transaction, 3DSecure is not supported.  Therfore, the app should skip this step and no longer provide a 3DSecureId
        guard !transaction.isApplePay else {
            //            check3dsActivityIndicator.isHidden = true
            //            check3dsStatusImageView.isHidden = true
            //            check3dsLabel?.attributedText = NSAttributedString(string: "Check 3DS Enrollment", attributes: [.strikethroughStyle: 1])
            transaction.threeDSecureId = nil
            processPayment()
            return
        }
        
        // update the UI
        //        check3dsActivityIndicator.startAnimating()
        
        // A redirect URL for 3D Secure that will redirect the browser back to a page on our merchant service after 3D Secure authentication
        let redirectURL = merchantAPI.merchantServerURL.absoluteString.appending("/3DSecureResult.php?3DSecureId=\(transaction.threeDSecureId!)")
        // check enrollment
        merchantAPI.check3DSEnrollment(transaction: transaction, redirectURL: redirectURL , completion: check3DSEnrollmentHandler)
    }
    
    func check3DSEnrollmentHandler(_ result: Result<GatewayMap>) {
        DispatchQueue.main.async {
            //            self.check3dsActivityIndicator.stopAnimating()
            if Int(self.transaction.session!.apiVersion)! <= 46 {
                self.check3DSEnrollmentV46Handler(result)
            } else {
                self.check3DSEnrollmentv47Handler(result)
            }
        }
    }
    
    func check3DSEnrollmentV46Handler(_ result: Result<GatewayMap>) {
        guard case .success(let response) = result, let code = response[at: "gatewayResponse.3DSecure.summaryStatus"] as? String else {
            //            self.stepErrored(message: "Error checking 3DS Enrollment", stepStatusImageView: self.check3dsStatusImageView)
            return
        }
        
        // check to see if the card was enrolled, not enrolled or does not support 3D Secure
        switch code {
        case "CARD_ENROLLED":
            // For enrolled cards, get the htmlBodyContent and present the Gateway3DSecureViewController
            if let html = response[at: "gatewayResponse.3DSecure.authenticationRedirect.simple.htmlBodyContent"] as? String {
                self.begin3DSAuth(simple: html)
            }
        case "CARD_DOES_NOT_SUPPORT_3DS":
            // for cards that do not support 3DSecure, go straight to payment confirmation without a 3DSecureID
            self.transaction.threeDSecureId = nil
            self.stepCompleted()
            self.processPayment()
        case "CARD_NOT_ENROLLED", "AUTHENTICATION_NOT_AVAILABLE":
            // for cards that are not enrolled or if authentication is not available, go to payment confirmation but include the 3DSecureID
            self.stepCompleted()
            self.processPayment()
        default:
            self.stepErrored(message: "Error checking 3DS Enrollment")
        }
    }
    
    func check3DSEnrollmentv47Handler(_ result: Result<GatewayMap>) {
        guard case .success(let response) = result, let recommendaition = response[at: "gatewayResponse.response.gatewayRecommendation"] as? String else {
            //            self.stepErrored(message: "Error checking 3DS Enrollment", stepStatusImageView: self.check3dsStatusImageView)
            return
        }
        
        // if DO_NOT_PROCEED returned in recommendation, should stop transaction
        if recommendaition == "DO_NOT_PROCEED" {
            //            self.stepErrored(message: "3DS Do Not Proceed", stepStatusImageView: self.check3dsStatusImageView)
        }
        
        // if PROCEED in recommendation, and we have HTML for 3DS, perform 3DS
        if let html = response[at: "gatewayResponse.3DSecure.authenticationRedirect.simple.htmlBodyContent"] as? String {
            self.begin3DSAuth(simple: html)
        } else {
            // if PROCEED in recommendation, but no HTML, finish the transaction without 3DS
            self.processPayment()
        }
    }
    
    fileprivate func begin3DSAuth(simple: String) {
        // instatniate the Gateway 3DSecureViewController and present it
        let threeDSecureView = Gateway3DSecureViewController(nibName: nil, bundle: nil)
//        threeDSecureView.modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            threeDSecureView.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }

        present(threeDSecureView, animated: true)
        
        // Optionally customize the presentation
        threeDSecureView.title = "3-D Secure Auth"
        //        threeDSecureView.navBar.tintColor = brandColor
        
        // Start 3D Secure authentication by providing the view with the HTML content provided by the check enrollment step
        threeDSecureView.authenticatePayer(htmlBodyContent: simple, handler: handle3DS(authView:result:))
    }
    
    func handle3DS(authView: Gateway3DSecureViewController, result: Gateway3DSecureResult) {
        // dismiss the 3DSecureViewController
        authView.dismiss(animated: true, completion: {
            switch result {
            case .error(_):
                self.stepErrored(message: "3DS Authentication Failed")
            case .completed(gatewayResult: let response):
                // check for version 46 and earlier api authentication failures and then version 47+ failures
                if Int(self.transaction.session!.apiVersion)! <= 46, let status = response[at: "3DSecure.summaryStatus"] as? String , status == "AUTHENTICATION_FAILED" {
                    self.stepErrored(message: "3DS Authentication Failed")
                } else if let status = response[at: "response.gatewayRecommendation"] as? String, status == "DO_NOT_PROCEED"  {
                    self.stepErrored(message: "3DS Authentication Failed")
                } else {
                    // if authentication succeeded, continue to proceess the payment
                    self.processPayment()
                }
            default:
                self.stepErrored(message: "3DS Authentication Cancelled")
            }
        })
    }
    
    
}

// MARK: - 5. Process Payment
extension ConfirmPurchaseViewController {
    /// Processes the payment by completing the session with the gateway.
    func processPayment() {
        // update the UI
        UtilityClass.showHUD()
        
        merchantAPI.completeSession(transaction: transaction) { (result) in
            DispatchQueue.main.async {
                self.processPaymentHandler(result: result)
            }
        }
    }
    
    
    func processPaymentHandler(result: Result<GatewayMap>) {
        UtilityClass.hideHUD()
        switch result {
        case .success(let response):
            
//            if let dictResponse = response["gatewayResponse"] as? [String:Any]
//            {
                if let orderDict = response["order"] as? [String:Any]
                {
                    if let strOrderID = orderDict["id"] as? String
                    {
                        orderDetails.transaction_id = strOrderID
                    }
                }
//            }
            
            print(JSON(response).string ?? "")
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: response.dictionary,
                options: [.prettyPrinted]) {
                let theJSONText = String(data: theJSONData,
                                         encoding: .ascii)
                orderDetails.payment_response = theJSONText ?? "-"
            }
            
            webserviceCallForPlaceOrder(model: orderDetails)
            
            print("Success Apple Pay")
            break
            
        default:
            self.stepErrored(message: "Unable to complete Pay Operation")
            return
        }
        
        //        guard case .success(let response) = result, "SUCCESS" == response[at: "gatewayResponse.result"] as? String else {
        //            self.stepErrored(message: "Unable to complete Pay Operation")
        //            return
        //        }
        
        
    }
}


// MARK: - Helpers
extension ConfirmPurchaseViewController {
    fileprivate func stepErrored(message: String, detail: String? = nil) {
        
    }
    
    fileprivate func stepCompleted() {
        
    }
    
    fileprivate func setAction(action: @escaping (() -> Void), title: String) {
        
    }
    
    fileprivate func randomID() -> String {
        return String(UUID().uuidString.split(separator: "-").first!)
    }
}


