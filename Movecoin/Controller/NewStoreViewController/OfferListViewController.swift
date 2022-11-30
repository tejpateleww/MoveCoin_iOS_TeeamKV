//
//  NewStoreViewController.swift
//  Movecoins
//
//  Created by Imac on 14/07/21.
//  Copyright © 2021 eww090. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import FirebaseAnalytics
class OfferListViewController: UIViewController {
    
    @IBOutlet weak var lblCatTitle: LocalizLabel?
    @IBOutlet weak var lblEmptyData: LocalizLabel!

    @IBOutlet weak var txtSearch: UITextField!
    lazy var search : String = ""
    lazy var isTyping: Bool = false

//    @IBOutlet weak var clnCategory: UICollectionView!
    @IBOutlet weak var tblStoreOffers: UITableView!
    @IBOutlet weak var viewCollection: UIView?
    
    var arrOffers : [Offer]?

    var filteredArray : [Offer]?
    {
        didSet
        {
            self.tblStoreOffers.reloadData()
        }
    }
    
//    var selectedIndexPath: IndexPath?
//    {
//        didSet
//        {
//            self.clnCategory.reloadData()
//        }
//    }
  
//    var arrCategories : [CategoriesDatum]?
//    {
//        didSet
//        {
//            self.clnCategory.reloadData()
//        }
//    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(webserviceForOfferList), for: .valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblStoreOffers.delegate = self
        self.tblStoreOffers.dataSource = self
//        self.clnCategory.allowsMultipleSelection = true

        self.PrepareView()
        Analytics.logEvent("OfferListScreen", parameters: nil)

        self.title = "Offers".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        txtSearch.placeholder = "Search".localized
        self.statusBarSetUp(backColor: .clear)
        self.viewCollection?.semanticContentAttribute = .forceLeftToRight
        self.webserviceForOfferList()
        self.lblCatTitle?.text = "Offers".localized
        self.view.layoutIfNeeded()
        self.navigationBarSetUp(title: "Offers".localized, backroundColor: .clear,foregroundColor: .white, hidesBackButton: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            if let info = object, let tblObj = info as? UITableView{
                if tblObj == self.tblStoreOffers{
//                    self.tblStoreOffersHeight.constant = self.tblStoreOffers.contentSize.height
//                    print(self.tblStoreOffersHeight.constant)
//                    if self.tblStoreOffers.contentSize.height >= 100 {
//                        self.tblStoreOffersHeight.constant = tblStoreOffers.contentSize.height
//                    } else {
//                        self.tblStoreOffersHeight.constant = 100
//                    }
                }
            }
        }
    }
    
    func PrepareView(){
        
        self.tblStoreOffers.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
//        self.scrollView.showsVerticalScrollIndicator = false
//        self.scrollView.showsHorizontalScrollIndicator = false
        
        
        lblCatTitle?.font = UIFont.regular(ofSize: 26)
        lblEmptyData.font = UIFont.regular(ofSize: 26)
        tblStoreOffers.addSubview(refreshControl)
        
//        self.lblMainVwTitle.text = "  Share the challenge  "
        tblStoreOffers.rowHeight = UITableView.automaticDimension
        tblStoreOffers.estimatedRowHeight = 215
        //tblStoreOffers.addSubview(refreshControl)
        txtSearch.font = UIFont.regular(ofSize: 15)

//        self.RegisterNIB()
    }
    
//    func RegisterNIB(){
//        self.clnCategory.register(UINib(nibName: StatusCollectionViewCell.className, bundle:nil), forCellWithReuseIdentifier: StatusCollectionViewCell.className)
//    }
    
    @IBAction func txtSearchEditingChangedAction(_ sender: UITextField) {
        let enteredText = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        isTyping = (enteredText?.isEmpty ?? false) ? false : true
        
        filteredArray = isTyping ? arrOffers?.filter{ $0.name.lowercased().contains(enteredText?.lowercased() ?? "")} ?? [] : self.arrOffers
        
        tblStoreOffers.reloadData()
    }
    
  
}

// ----------------------------------------------------
//MARK:- --------- Tableview Methods ---------
// ----------------------------------------------------
extension OfferListViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewStoreTableViewCell.className) as! NewStoreTableViewCell
        cell.selectionStyle = .none
        cell.product = filteredArray?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: ProductDetailViewController.className) as! ProductDetailViewController
        let product = filteredArray?[indexPath.row]
        controller.productID = product?.id
        self.parent?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
}


//MARK: - CollectionView Delegate and DataSource Methods
/*extension OfferListViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCategories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusCollectionViewCell.className, for: indexPath) as! StatusCollectionViewCell
        cell.lblCategory.text = self.arrCategories?[indexPath.item].categoryName
        
        if (self.selectedIndexPath != nil && indexPath == self.selectedIndexPath)
        {
            cell.vWcell.backgroundColor = UIColor.red
        }
        else {
            cell.vWcell.backgroundColor = ThemeBlueColor
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategoryIndex = self.arrCategories?[indexPath.item].iD
        self.filteredArray = self.arrOffers?.filter{$0.categoryId == selectedCategoryIndex}
        self.selectedIndexPath = indexPath
        if(selectedIndexPath?.item == 0)
        {
            self.filteredArray = self.arrOffers
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = self.arrCategories?[indexPath.item].categoryName
        label.sizeToFit()
        return CGSize(width: label.frame.width + 20, height: collectionView.frame.height)
    }
}
*/
extension OfferListViewController {

    @objc func webserviceForOfferList()
    {
        OffersWebserviceSubclass.offerList { json, status, res in
            self.refreshControl.endRefreshing()
//            self.webserviceForCategoryList()
            let response = OfferList(fromJson: json)
            self.arrOffers = response.offers
            self.filteredArray = self.arrOffers
            self.lblEmptyData.isHidden = true
            if(self.filteredArray?.count == 0)
            {
                self.lblEmptyData.isHidden = false
            }
        }
    }
    
   /*@objc func webserviceForCategoryList()
    {
        ChallengWebserviceSubclass.getCategoryList { json, status, res in
            self.refreshControl.endRefreshing()
            if status {
                let response = CategoryData(fromJson: json)
                self.arrCategories = response.categoriesData
                self.selectedIndexPath = IndexPath(item: 0, section: 0)
                var dictData = [String:Any]()
                dictData["CategoryName"] = "All".localized
                dictData["ID"] = "0"
                self.arrCategories?.insert(CategoriesDatum(fromJson: JSON(dictData)), at: 0)//.append(CategoriesDatum(fromJson: JSON(dictData)))
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }*/
    
}

