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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var viewShadow: UIView!
    
    @IBOutlet weak var txtvwDescription: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblStore: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblBuy: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
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
        navigationBarSetUp()
        self.setUpView()
        self.setupFont()
        guard productID != nil else { return }
        webserviceForProductDetails()
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidAppear(true)
         setGradientColorOfView(view: viewShadow, startColor: UIColor.black, endColor: UIColor.clear)
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
        lblPrice.font = UIFont.semiBold(ofSize: 19)
        lblTitle.font = UIFont.bold(ofSize: 26)
        lblDescription.font = UIFont.bold(ofSize: 16)
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
        
        lblStore.text = "Store : " + product.store
        if product.discount != "0" {
             lblTitle.text = product.name + " with \(product.discount!)% Discount"
        }else {
            lblTitle.text = product.name
        }
        
        if product.status == "Out Stock" {
            stackView.isHidden = true
            btnBuy.isEnabled = false
            btnBuy.backgroundColor = .lightText
            btnBuy.setTitle("Out of Stock", for: .normal)
        }else{
             lblPrice.text = product.coins
        }
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnPurchaseTapped(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: ConfirmPurchaseViewController.className) as! ConfirmPurchaseViewController
        controller.product = product
        self.navigationController?.pushViewController(controller, animated: true)
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
        controller.imageArray = imgArray
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
