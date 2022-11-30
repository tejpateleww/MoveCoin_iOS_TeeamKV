//
//  ProductDetailViewController.swift
//  Movecoin
//
//  Created by eww090 on 13/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import Cosmos
import FirebaseAnalytics
class ProductDetailViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var viewShadow: UIView!
    
    @IBOutlet weak var txtvwDescription: UITextView!
    @IBOutlet weak var txtvwOfferDetails: UITextView!
    @IBOutlet weak var txtvwHowToClaim: UITextView!
    @IBOutlet weak var lblTitle: LocalizLabel!
    @IBOutlet weak var lblStore: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDiscountedPrice: UILabel!
    @IBOutlet weak var lblPriceDiscount: UILabel!
    @IBOutlet weak var lblTitleHowToClaim: LocalizLabel!
    @IBOutlet weak var lblTitleOfferDetails: LocalizLabel!
    
    @IBOutlet weak var lblDescription: LocalizLabel?
    @IBOutlet weak var lblOfferDetails: LocalizLabel?
    @IBOutlet weak var lblHowToClaim: LocalizLabel?
    
    @IBOutlet weak var lblDeliveryCharge: UILabel!
    @IBOutlet weak var lblBuy: UILabel!
    @IBOutlet weak var lblCoins: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var vwContainerButton: UIView?
    @IBOutlet weak var vWGoToStore: UIView?
    @IBOutlet weak var btnGoToStore: LocalizButton?
    
    
    var strOrderStatus = String()
    let userData = SingletonClass.SharedInstance.userData

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var productID: String?
    var thisWidth: CGFloat = 0
    
    var imgArray : [String] = []
    var viewType : PurchaseDetailViewType = .Purchase
    //    var product : ProductDetails!
    //    var orderDetail : Order!
    
    var offerDetail : OfferDetailsModel!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        DispatchQueue.main.async {
            self.webserviceForOfferDetails(productId: self.productID ?? "0")
//        }
        self.setUpView()
        self.setupFont()
        collectionView.semanticContentAttribute = .unspecified
        setGradientColorOfView(view: viewShadow, startColor: UIColor.black.withAlphaComponent(0.15), endColor: UIColor.clear.withAlphaComponent(0))
        vwContainerButton?.layer.cornerRadius = (vwContainerButton?.frame.height ?? 0)/2
        vwContainerButton?.layer.masksToBounds = true
        vwContainerButton?.backgroundColor = .white
        self.statusBarSetUp(backColor: .clear)
        self.navigationController?.navigationBar.tintColor = .white
        self.title = "Title_offer_details".localized
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationBarSetUp(title: "Title_offer_details".localized, backroundColor: .clear,foregroundColor: .white, hidesBackButton: false)

    }
    
 /*   override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setGradientColorOfView(view: viewShadow, startColor: UIColor.black.withAlphaComponent(0.15), endColor: UIColor.clear.withAlphaComponent(0))
        vwContainerButton?.layer.cornerRadius = (vwContainerButton?.frame.height ?? 0)/2
        vwContainerButton?.layer.masksToBounds = true
        vwContainerButton?.backgroundColor = .white
    }*/
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        thisWidth = windowWidth
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pageControl.hidesForSinglePage = true
        pageControl.isUserInteractionEnabled = false
        
        viewShadow.isUserInteractionEnabled = false
        lblTitleHowToClaim.text = "title_how_to_claim".localized
        lblTitleOfferDetails.text = "message_offer_details".localized
        
        lblTitleHowToClaim.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        lblTitleOfferDetails.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left

        btnGoToStore?.setTitle("title_go_to_store".localized, for: .normal)
        switch viewType     {
        case .History:
            viewBottom.isHidden = true
            break
            
        default:
            break
        }
        
        self.vWGoToStore?.layer.masksToBounds = true
        self.vWGoToStore?.layer.maskedCorners = [.layerMinXMinYCorner , .layerMinXMaxYCorner , .layerMaxXMaxYCorner , .layerMaxXMinYCorner]
        self.vWGoToStore?.layer.cornerRadius = 25.0
        
        self.btnGoToStore?.titleEdgeInsets = (Localize.currentLanguage() == Languages.Arabic.rawValue) ?  UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 20) :  UIEdgeInsets(top: 0, left: 20, bottom: 3, right: 0)
    }
    
    func setupFont(){
        lblBuy.font = UIFont.regular(ofSize: 19)
        lblCoins.font = UIFont.regular(ofSize: 19)
        lblDiscountedPrice.font = UIFont.regular(ofSize: 22)
        lblPrice.font = UIFont.regular(ofSize: 16)
        lblPriceDiscount.font = UIFont.regular(ofSize: 14)
        lblTitle.font = UIFont.regular(ofSize: 20)
        //lblDescription.font = UIFont.regular(ofSize: 16)
        lblDescription?.font = UIFont.regular(ofSize: 16)
        lblStore.font = UIFont.regular(ofSize: 14)
        lblTitleHowToClaim.font = UIFont.regular(ofSize: 22)
        lblTitleOfferDetails.font = UIFont.regular(ofSize: 22)
        lblOfferDetails?.font = UIFont.regular(ofSize: 16)
        lblHowToClaim?.font = UIFont.regular(ofSize: 16)
        btnGoToStore?.titleLabel?.font = UIFont.regular(ofSize: 20)
    }
    
    
    func setupOfferData(){
        // For Images
        imgArray.append(NetworkEnvironment.baseImageURL + offerDetail.offerDetails.image)
        pageControl.numberOfPages = imgArray.count
        collectionView.reloadData()
      
        
        lblDescription?.text = offerDetail.offerDetails.descriptionField
//        lblDescription?.textAlignment = .left
        lblOfferDetails?.text = offerDetail.offerDetails.offerDetails
//        lblOfferDetails?.textAlignment = .left
        lblHowToClaim?.text = offerDetail.offerDetails.howToClaim
//        lblHowToClaim?.textAlignment = .left
//        self.lblTitle?.textAlignment = .left
        // For the textview proper width and height according to content
        var fixedWidth = txtvwDescription.frame.size.width - 20
        var newSize = txtvwDescription.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        txtvwDescription.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        fixedWidth = txtvwHowToClaim.frame.size.width - 20
        newSize = txtvwHowToClaim.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        txtvwHowToClaim.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        fixedWidth = txtvwOfferDetails.frame.size.width - 20
        newSize = txtvwOfferDetails.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        txtvwOfferDetails.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        lblTitle.text = offerDetail.offerDetails.name
        //lblStore.text = "Store : ".localized + product.store
        
        lblCoins.text = offerDetail.offerDetails.coins
        
        viewBottom.semanticContentAttribute = .forceLeftToRight

    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnPurchaseTapped(_ sender: Any) {
        
        if(validateCoins())
        {
            UtilityClass.showAlertWithTwoButtonCompletion(title: kAppName, Message: "message_confirmation_buy_offer".localized, ButtonTitle1: "OK".localized, ButtonTitle2: "Cancel".localized) { index in
                if(index == 0)
                {
                    self.webserviceCallForjoiningOffer()
                }
            }
            
        }
    }
    
    func validateCoins() -> Bool
    {
        
        var availableCoins = 0.0
        var productCoins = 0.0
        
        if let coins = userData?.coins {
            availableCoins = Double(coins) ?? 0.0
        }
        
        if let coins = self.offerDetail.offerDetails.coins {
            productCoins = Double(coins) ?? 0.0
        }
        
        if availableCoins < productCoins {
            var msg = ""
            
            msg = "Your current balance is too low to purchase ".localized + self.offerDetail.offerDetails.name! + ". Don't want to wait? Invite Friends and Family to earn faster!".localized
            
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
    
    func navigateToBalanceScreen()
    {
        let parentVC = self.parent?.children.first as? TabViewController
        parentVC?.btnTabTapped(parentVC?.btnTabs[TabBarOptions.Wallet.rawValue] ?? 1)
        self.navigationController?.popViewController(animated: false)
    }
    
   
    @IBAction func goToStore(_ sender: Any) {
        UIApplication.shared.open((URL(string:offerDetail.offerDetails.link) ?? URL(fileURLWithPath: "")) as URL)
    }
    

    func webserviceCallForjoiningOffer()
    {
        
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
        let redeemOffers = RedeemOffers()
        redeemOffers.too_id = productID ?? ""
        redeemOffers.user_id = id
        UtilityClass.showHUD()
        OffersWebserviceSubclass.redeemOffer(dictRedeemOffer: redeemOffers) { json, status, res in
            UtilityClass.hideHUD()
            if(status)
            {
                self.navigateToBalanceScreen()
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
            else
            {
                self.navigateToBalanceScreen()
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- CollectionView Methods ---------
// ----------------------------------------------------

extension ProductDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailCollectionViewCell.className, for: indexPath) as! ProductDetailCollectionViewCell
        cell.productImage = imgArray[indexPath.section]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = windowWidth
        return CGSize(width: thisWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: ImagesViewController.className) as! ImagesViewController
        controller.imageArray = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? imgArray.reversed() : imgArray
        self.present(controller, animated: true, completion: nil)
    }
}

// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension ProductDetailViewController {
    
    func webserviceForOfferDetails(productId : String = ""){
        
        UtilityClass.showHUD()
        
        let productsURL = NetworkEnvironment.baseURL + ApiKey.offerDetails.rawValue + "/" + productId
        OffersWebserviceSubclass.getOfferDetails(strURL: productsURL){ (json, status, res) in
            UtilityClass.hideHUD()
            
            if status {
                self.offerDetail = OfferDetailsModel(fromJson: json)
                self.setupOfferData()
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
}


