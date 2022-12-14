//
//  StoreViewController.swift
//  Movecoin
//
//  Created by eww090 on 12/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import FirebaseAnalytics
class StoreViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------

    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var tblStoreOffers: UITableView!
    
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var lblSeller: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnGetInTouch: UIButton!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var productArray : [ProductDetails] = []
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(webserviceForProductList), for: .valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpView()
        self.setupFont()
        self.title = "Offers For Today".localized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Navigation & Status bar setup
        self.navigationBarSetUp(title: "Offers For Today", backroundColor: ThemeNavigationColor, hidesBackButton: true)
        self.statusBarSetUp(backColor: ThemeNavigationColor)
        
        webserviceForProductList()
        localizeSetup()
        Analytics.logEvent("StoresScreen", parameters: nil)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.viewFooter.isHidden = true
        sizeFooterToFit()
        setButtonLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationBarSetUp()
        self.statusBarSetUp(backColor: .clear)
        self.title = ""
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
//        tblStoreOffers.delegate = self
//        tblStoreOffers.dataSource = self
        tblStoreOffers.rowHeight = UITableView.automaticDimension
        tblStoreOffers.estimatedRowHeight = 215
        tblStoreOffers.addSubview(refreshControl)
    }
    
    func localizeSetup(){
        // Localization
        lblSeller.text = "Be a Seller".localized
        lblDescription.text = "Do you have a product or service you would like to show in our marketplace.".localized
        lblDescription.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        self.btnGetInTouch.setTitle("Get In Touch".localized, for: .normal)
    }
    
    func setupFont(){
        lblSeller.font = UIFont.regular(ofSize: 26)
        lblDescription.font = UIFont.regular(ofSize: 17)
    }
    
    func setButtonLayout() {
        btnGetInTouch.backgroundColor = .white
        btnGetInTouch.setTitleColor(ThemeBlueColor, for: .normal)
        btnGetInTouch.layer.cornerRadius = btnGetInTouch.frame.size.height / 2
        //        self.clipsToBounds = true
        btnGetInTouch.layer.masksToBounds = true
        btnGetInTouch.titleLabel?.font = UIFont(name: FontBook.SemiBold.rawValue, size: 20.0)
    }
    
    func sizeFooterToFit() {
        if let footerView = tblStoreOffers.tableFooterView {
            let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = viewFooter.frame
            frame.size.height = height //0
            footerView.frame = frame
            tblStoreOffers.tableFooterView = footerView
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- Tableview Methods ---------
// ----------------------------------------------------


extension StoreViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreTableViewCell.className) as! StoreTableViewCell
        cell.selectionStyle = .none
        cell.product = productArray[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: ProductDetailViewController.className) as! ProductDetailViewController
//        let product = productArray[indexPath.row]
//        controller.productID = product.iD
//        self.parent?.navigationController?.pushViewController(controller, animated: true)
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: OfferListViewController.className) as! OfferListViewController
        self.parent?.navigationController?.pushViewController(controller, animated: true)
    }
}


// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension StoreViewController {
    
    @objc func webserviceForProductList(){
        
        let productsURL = NetworkEnvironment.baseURL + ApiKey.productsList.rawValue
        ProductWebserviceSubclass.productsList(strURL: productsURL){ (json, status, res) in
            self.refreshControl.endRefreshing()
            
            if status {
                let responseModel = ProductsResponseModel(fromJson: json)
//                if responseModel.productsList.count > 0  {
                    self.productArray = responseModel.productsList
                    self.tblStoreOffers.reloadData()
//                }
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
