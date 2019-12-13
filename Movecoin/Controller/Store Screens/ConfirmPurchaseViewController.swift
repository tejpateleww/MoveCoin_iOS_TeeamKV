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
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblAvailableBalance: UILabel!
    @IBOutlet weak var lblPurchase: UILabel!
    @IBOutlet var lblPrice: [UILabel]!
    @IBOutlet weak var viewCardSelect: UIView!
 
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
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    lazy var card = Card()
    var product : ProductDetails!
    let userData = SingletonClass.SharedInstance.userData
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
        setupView()
        setupProductData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationBarSetUp()
        self.title =  "Confirm Purchase"
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
        
        lblTotal.font = UIFont.semiBold(ofSize: 19)
        lblAddress.font = UIFont.semiBold(ofSize: 23)
        lblPurchase.font = UIFont.semiBold(ofSize: 19)
        lblAvailableBalance.font = UIFont.bold(ofSize: 18)
    }
    
    func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.cardViewTapped(_:)))
        viewCardSelect.addGestureRecognizer(tap)
        viewCardSelect.isUserInteractionEnabled = true
        imgCardIcon.isHidden = true
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
        }
        if let user = userData {
            lblAvailableBalance.text = "Now Available balance - \(user.coins ?? "0")"
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
                if txtCard.text!.isBlank {
                    UtilityClass.showAlert(Message: "Please select card")
                    return
                }
                
                let requestModel = PlaceOrder()
                requestModel.name = name
                requestModel.phone = number
                requestModel.email = email
                requestModel.address1 = address1
                requestModel.address2 = address2
                requestModel.country = country
                requestModel.state = state
                requestModel.city = city
                requestModel.zip = zipcode
                requestModel.card_id = card.id
                requestModel.product_id = product.iD
                requestModel.user_id = SingletonClass.SharedInstance.userData?.iD ?? ""
                
                webserviceCallForPlaceOrder(model: requestModel)
                
            } catch(let error) {
                UtilityClass.showAlert(Message: (error as! ValidationError).message)
            }
        }
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnPurchaseTapped(_ sender: Any) {
        var productCoins = 0.0
        var availableCoins = 0.0
        
        if let coins = product.coins {
            productCoins = Double(coins)!
        }
        if let coins = userData?.coins{
            availableCoins = Double(coins)!
        }
        
        if availableCoins < productCoins {
            var msg = ""
            if let discount = product.discount, discount != "0" {
                msg = "Your current balance is too low to purchase \(discount)% off \(product.name!). Don't want to wait? invite Friends and Family to earn faster!"
            } else {
                msg = "Your current balance is too low to purchase \(product.name!). Don't want to wait? invite Friends and Family to earn faster!"
            }
            let destination = self.storyboard?.instantiateViewController(withIdentifier: AlertViewController.className) as! AlertViewController
                   destination.alertTitle = "Insufficient Balance"
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
// MARK: - --------- CardDelegate Methods ---------
// ----------------------------------------------------

extension ConfirmPurchaseViewController : CardDelegate {
    
    func setCardDetails(value: Card) {
        card = value
        txtCard.text = value.cardNum
        imgCardIcon.isHidden = false
        let type = value.type.lowercased()
        imgCardIcon.image = UIImage(named: "\(type)-white")
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
            print(json)
           
            if status{
              
                UtilityClass.showAlertWithCompletion(title: "", Message: json["message"].stringValue, ButtonTitle: "OK", Completion: {
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
