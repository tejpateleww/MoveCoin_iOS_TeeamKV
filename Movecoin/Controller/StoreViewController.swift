//
//  StoreViewController.swift
//  Movecoin
//
//  Created by eww090 on 12/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------

    @IBOutlet weak var tblStoreOffers: UITableView!
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        tblStoreOffers.delegate = self
        tblStoreOffers.dataSource = self
        tblStoreOffers.tableFooterView = UIView.init(frame: CGRect.zero)
        tblStoreOffers.rowHeight = UITableView.automaticDimension
        tblStoreOffers.estimatedRowHeight = 215
        
        // Navigation & Status bar setup
        self.navigationBarSetUp(title: "Offers For Today", backroundColor: ThemeNavigationColor)
        self.statusBarSetUp(backColor: ThemeNavigationColor, textStyle: UIBarStyle.blackTranslucent)
    }
}

extension StoreViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreTableViewCell.className) as! StoreTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ProductDetailViewController.className) as! ProductDetailViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
