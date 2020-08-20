//
//  ProductDetailViewController.swift
//  Movecoin
//
//  Created by eww090 on 13/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import Cosmos

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
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblStore: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDiscountedPrice: UILabel!
    @IBOutlet weak var lblPriceDiscount: UILabel!
    
    @IBOutlet weak var lblDeliveryCharge: UILabel!
    @IBOutlet weak var lblBuy: UILabel!
    @IBOutlet weak var lblCoins: UILabel!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var productID: String?
    var thisWidth: CGFloat = 0
    
    var imgArray : [String] = []
    var viewType : PurchaseDetailViewType = .Purchase
    var product : ProductDetails!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        webserviceForProductDetails()

        navigationBarSetUp()
        self.setUpView()
        self.setupFont()
       
        guard productID != nil else { return }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidAppear(true)
         setGradientColorOfView(view: viewShadow, startColor: UIColor.black.withAlphaComponent(0.15), endColor: UIColor.clear.withAlphaComponent(0))
    }
    
    
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
        
        switch viewType {
        case .History:
            viewBottom.isHidden = true
            break
            
        default:
            break
        }
    }
    
    func setupFont(){
        lblBuy.font = UIFont.semiBold(ofSize: 19)
        lblCoins.font = UIFont.semiBold(ofSize: 19)
        lblDiscountedPrice.font = UIFont.semiBold(ofSize: 22)
        lblPrice.font = UIFont.regular(ofSize: 16)
        lblPriceDiscount.font = UIFont.regular(ofSize: 14)
        lblTitle.font = UIFont.bold(ofSize: 20)
//        lblDescription.font = UIFont.bold(ofSize: 16)
        txtvwDescription.font = UIFont.bold(ofSize: 16)
        lblStore.font = UIFont.regular(ofSize: 14)
    }
    
    func setupProductData(){
        // For Images
//        imgArray = self.product.gallery.components(separatedBy: ",")
        imgArray = self.product.gallaries
        pageControl.numberOfPages = imgArray.count
        collectionView.reloadData()
        
        // For Data
        if let rating = product.avgRatings {
            viewRating.rating = Double(rating) ?? 0
        }
       
//        lblDescription.attributedText = product.descriptionField.html2Attributed
//        lblDescription.text = product.descriptionField
        txtvwDescription.text = product.descriptionField
        txtvwDescription.translatesAutoresizingMaskIntoConstraints = true
        txtvwDescription.sizeToFit()
        txtvwDescription.isScrollEnabled = false
        txtvwDescription.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        
        lblTitle.text = product.name
        lblStore.text = "Store : ".localized + product.store
/*
        if product.discount != "0" {
//             lblTitle.text = product.name + " with \(product.discount!)% Discount"
            let priceText = "$\(product.price ?? "") $\(product.totalPrice ?? "")" + " inclusive tax".localized
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: priceText)
            let attributeString1: NSMutableAttributedString =  NSMutableAttributedString(string: "$\(product.price ?? "")")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString1.length))
            self.lblPrice.attributedText = attributeString
        }else {
//            lblTitle.text = product.name
            lblPrice.text = "$\(product.price!)" + " inclusive tax".localized
        }
*/
        if product.discount == "0" {
            self.lblDiscountedPrice.text = ""
            self.lblDiscountedPrice.isHidden = true
            self.lblPrice.text = currency.localized + " \(product.price ?? "")"
            self.lblPriceDiscount.text = ""
            self.lblPriceDiscount.isHidden = true
        } else {
            self.lblDiscountedPrice.text = currency.localized + " \(product.discountedPrice ?? "")"
            self.lblDiscountedPrice.isHidden = false
            
            let priceText = currency.localized + " \(product.price ?? "")"
            self.lblPrice.text = currency.localized + " \(product.price ?? "")"
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: priceText)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            self.lblPrice.attributedText = attributeString
            
            self.lblPriceDiscount.text = " \(product.discount ?? "")%   "
            self.lblPriceDiscount.isHidden = false
        }
/*
        var productPrice = 0
        var chargeLimit = 0
        
        if let charge = product.price {
            productPrice = Int(charge)!
        }
        if let charge = product.deliveryChargePurchaseLimit {
            chargeLimit = Int(charge)!
        }
        
        if productPrice < chargeLimit {
        lblDeliveryCharge.isHidden = false
        lblDeliveryCharge.text = "Delivery Charge : ".localized + product.deliveryCharge + " \(currency.localized)"
        } else {
            lblDeliveryCharge.isHidden = true
        }
 
 */
        
        if product.status == "Out Stock" {
            stackView.isHidden = true
            btnBuy.isEnabled = false
            btnBuy.backgroundColor = .lightText
            btnBuy.setTitle("Out of Stock".localized, for: .normal)
        }else{
             lblCoins.text = product.coins
        }
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnPurchaseTapped(_ sender: Any) {
        
        if product != nil {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: ConfirmPurchaseViewController.className) as! ConfirmPurchaseViewController
            controller.product = product
            controller.closure = { str in
                    print(str)
                self.webserviceForProductDetails()
            }
            self.navigationController?.pushViewController(controller, animated: true)
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
    
    func webserviceForProductDetails(){
        
        UtilityClass.showHUD()
        
        let requestModel = ProductDetailModel()
        requestModel.ProductID = productID ?? ""
    
        ProductWebserviceSubclass.productDetails(productDetailModel: requestModel){ (json, status, res) in
          
            UtilityClass.hideHUD()
            
            if status {
                let responseModel = ProductDetailResponseModel(fromJson: json)
                if let data = responseModel.data {
                    self.product = data
                    self.setupProductData()
                }
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
