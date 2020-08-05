//
//  PurchaseHistoryViewController.swift
//  Movecoin
//
//  Created by eww090 on 16/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class PurchaseHistoryViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var tblPurchaseHistory: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var purchaseHistory : [Order]?
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        localizeUI(parentView: self.viewParent)
        self.setUpView()
        webserviceForPurchasehistory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(title: "Purchase History")
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        self.tblPurchaseHistory.delegate = self
        self.tblPurchaseHistory.dataSource = self
        self.tblPurchaseHistory.tableFooterView = UIView.init(frame: CGRect.zero)
        
        lblNoDataFound.isHidden = true
    }
}

// ----------------------------------------------------
//MARK:- --------- Tableview Delegate Methods ---------
// ----------------------------------------------------

extension PurchaseHistoryViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseHistory?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseHistoryTableViewCell.className) as! PurchaseHistoryTableViewCell
        cell.selectionStyle = .none
        cell.orderDetail = purchaseHistory?[indexPath.row]
//        localizeUI(parentView: cell.contentView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: ProductDetailViewController.className) as! ProductDetailViewController
        controller.viewType = .History
        controller.productID = purchaseHistory?[indexPath.row].productId
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension PurchaseHistoryViewController {
    
    func webserviceForPurchasehistory(){
        
        UtilityClass.showHUD()
           
        let requestModel = PurchaseHistory()
        requestModel.UserID = SingletonClass.SharedInstance.userData?.iD ?? ""
    
        OrderWebserviceSubclass.purchaseHistory(purchaseHistoryModel: requestModel){ (json, status, res) in
            
            UtilityClass.hideHUD()
            if status {
                let responseModel = PurchaseHistoryResponseModel(fromJson: json)
                if responseModel.data.count > 0  {
                    self.purchaseHistory = responseModel.data
                    self.tblPurchaseHistory.reloadData()
                }
            }
        }
    }
}
