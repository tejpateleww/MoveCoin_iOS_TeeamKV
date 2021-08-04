//
//  NewStoreViewController.swift
//  Movecoins
//
//  Created by Imac on 14/07/21.
//  Copyright © 2021 eww090. All rights reserved.
//

import UIKit

class NewStoreViewController: UIViewController {
    
    @IBOutlet weak var VwTopMain: UIView!
    @IBOutlet weak var lblMainVwTitle: LocalizLabel!
    @IBOutlet weak var lblMainVwTitleDesc: LocalizLabel!
    @IBOutlet weak var lblMainVwBottomTitle: LocalizLabel!
    @IBOutlet weak var lblCatTitle: LocalizLabel!
    
    @IBOutlet weak var clnCategory: UICollectionView!
    @IBOutlet weak var tblStoreOffers: UITableView!
    @IBOutlet weak var tblStoreOffersHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var arrStatus = ["Everything","Health","Beauty","Clothes","Electronics"]
    var productArray : [ProductDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.PrepareView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Navigation & Status bar setup
        self.navigationController?.navigationBar.isHidden = false
        self.navigationBarSetUp(title: "Offers For Today", backroundColor: ThemeBlueColor, hidesBackButton: false)
        self.statusBarSetUp(backColor: ThemeBlueColor)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationBarSetUp()
        self.statusBarSetUp(backColor: .clear)
        self.title = ""
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            if let info = object, let tblObj = info as? UITableView{
                if tblObj == self.tblStoreOffers{
                    self.tblStoreOffersHeight.constant = self.tblStoreOffers.contentSize.height
                    print(self.tblStoreOffersHeight.constant)
                    if self.tblStoreOffers.contentSize.height >= 100 {
                        self.tblStoreOffersHeight.constant = tblStoreOffers.contentSize.height
                    } else {
                        self.tblStoreOffersHeight.constant = 100
                    }
                }
            }
        }
    }
    
    func PrepareView(){
        
        self.tblStoreOffers.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        
        self.topViewHeight.constant = 180 //(UIScreen.main.bounds.size.height / 3.5)
        
        self.VwTopMain.layer.masksToBounds = true
        self.VwTopMain.layer.maskedCorners = [.layerMinXMinYCorner , .layerMinXMaxYCorner , .layerMaxXMaxYCorner , .layerMaxXMinYCorner]
        self.VwTopMain.layer.cornerRadius = 30.0
        
        lblMainVwTitle.font = UIFont.bold(ofSize: 20)
        lblMainVwTitleDesc.font = UIFont.regular(ofSize: 16)
        lblMainVwBottomTitle.font = UIFont.bold(ofSize: 20)
        lblCatTitle.font = UIFont.bold(ofSize: 26)
        
        tblStoreOffers.rowHeight = UITableView.automaticDimension
        tblStoreOffers.estimatedRowHeight = 215
        //tblStoreOffers.addSubview(refreshControl)
        
        self.RegisterNIB()
        self.webserviceForProductList()
    }
    
    
    func RegisterNIB(){
        self.clnCategory.register(UINib(nibName: StatusCollectionViewCell.className, bundle:nil), forCellWithReuseIdentifier: StatusCollectionViewCell.className)
    }
    
    @IBAction func btnVwHeaderAction(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: LeaderboardViewController.className) as! LeaderboardViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    

}

// ----------------------------------------------------
//MARK:- --------- Tableview Methods ---------
// ----------------------------------------------------
extension NewStoreViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewStoreTableViewCell.className) as! NewStoreTableViewCell
        cell.selectionStyle = .none
        cell.product = productArray[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: ProductDetailViewController.className) as! ProductDetailViewController
        let product = productArray[indexPath.row]
        controller.productID = product.iD
        self.parent?.navigationController?.pushViewController(controller, animated: true)
        
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: LeaderboardViewController.className) as! LeaderboardViewController
//        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
}

//MARK: - CollectionView Delegate and DataSource Methods
extension NewStoreViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusCollectionViewCell.className, for: indexPath) as! StatusCollectionViewCell
        cell.lblCategory.text = self.arrStatus[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = self.arrStatus[indexPath.item]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 20, height: collectionView.frame.height)
    }
}

extension NewStoreViewController {
    
    @objc func webserviceForProductList(){
        
        let productsURL = NetworkEnvironment.baseURL + ApiKey.productsList.rawValue
        ProductWebserviceSubclass.productsList(strURL: productsURL){ (json, status, res) in
            //self.refreshControl.endRefreshing()
            
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
