//
//  StoreViewController.swift
//  Movecoin
//
//  Created by eww090 on 12/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

struct ProductDetail {
    var discount : String
    var price : String
    var name : String
    var image : String
}

class StoreViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------

    @IBOutlet weak var tblStoreOffers: UITableView!
    
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var lblSeller: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    var productArray : [ProductDetail] = []
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupFont()
        
        let product1 = ProductDetail(discount: "30", price: "20.55", name: "Xiaomi-Mi-9", image: "1.jpg")
        let product2 = ProductDetail(discount: "30", price: "10.55", name: "Apple Airpods", image: "3.jpg")
        let product3 = ProductDetail(discount: "25", price: "9.95", name: "Sony Headphone", image: "headphone.jpg")
        let product4 = ProductDetail(discount: "12", price: "8.65", name: "Bluetooth-Speaker", image: "bluetooth-speaker.jpg")
        let product5 = ProductDetail(discount: "10", price: "5.98", name: "JBL Handsfree", image: "2.jpg")
        productArray = [product1,product2,product3,product4,product5]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // Navigation & Status bar setup
        self.navigationBarSetUp(title: "Offers For Today", backroundColor: ThemeNavigationColor, hidesBackButton: true)
        self.statusBarSetUp(backColor: ThemeNavigationColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationBarSetUp()
        self.statusBarSetUp(backColor: .clear)
        self.title = ""
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeFooterToFit()
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        tblStoreOffers.delegate = self
        tblStoreOffers.dataSource = self
        tblStoreOffers.rowHeight = UITableView.automaticDimension
        tblStoreOffers.estimatedRowHeight = 215
    }
    
    func setupFont(){
        lblSeller.font = UIFont.bold(ofSize: 26)
        lblDescription.font = UIFont.regular(ofSize: 17)
    }
    
    func sizeFooterToFit() {
        if let footerView = tblStoreOffers.tableFooterView {
            let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = viewFooter.frame
            frame.size.height = height
            footerView.frame = frame
            tblStoreOffers.tableFooterView = footerView
        }
    }
}

extension StoreViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreTableViewCell.className) as! StoreTableViewCell
        cell.selectionStyle = .none
        cell.productDetail = productArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: ProductDetailViewController.className) as! ProductDetailViewController
        self.parent?.navigationController?.pushViewController(controller, animated: true)
    }
}
