//
//  WalletViewController.swift
//  Movecoin
//
//  Created by eww090 on 16/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

struct WalletDetail {
    var discription : String
    var amount : String
}

class WalletViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var tblWallet: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAmount: UIButton!
    @IBOutlet weak var btnSpendCoins: UIButton!
    @IBOutlet weak var btnTransfer: UIButton!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
   
    var walletArray : [WalletDetail] = []
    
//    var delegateWalletCoins : WalletCoinsDelegate!
    
    var walletType = WalletViewType.Wallet
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupFont()
        
        let transaction1 = WalletDetail(discription: "Bonus", amount: "+1")
        let transaction2 = WalletDetail(discription: "Send to Aadam", amount: "-300")
        let transaction3 = WalletDetail(discription: "Bonus", amount: "+6")
        let transaction4 = WalletDetail(discription: "Bonus", amount: "+3")
        let transaction5 = WalletDetail(discription: "Receive from Aafeen", amount: "")
        let transaction6 = WalletDetail(discription: "Bonus", amount: "+15")
        let transaction7 = WalletDetail(discription: "Receive from Aafeen", amount: "")
        walletArray = [transaction1,transaction2,transaction3,transaction4,transaction5,transaction6,transaction7]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationBarSetUp()
        
        switch walletType {
        case .Coins:
            btnBack.isHidden = false
            break
         case .Wallet:
            btnBack.isHidden = true
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationBarSetUp()
        walletType = .Wallet
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        tblWallet.delegate = self
        tblWallet.dataSource = self
        tblWallet.tableFooterView = UIView.init(frame: CGRect.zero)
//        tblWallet.rowHeight = UITableView.automaticDimension
//        tblWallet.estimatedRowHeight = 60
        
//        delegateWalletCoins = self
    }
   
    func setupFont(){
        lblTitle.font = UIFont.semiBold(ofSize: 28)
        btnAmount.titleLabel?.font = UIFont.semiBold(ofSize: 33)
        btnTransfer.titleLabel?.font = UIFont.bold(ofSize: 17)
        btnSpendCoins.titleLabel?.font = UIFont.bold(ofSize: 17)
    }
    
    // ----------------------------------------------------
    // MARK: - IBAction Methods
    // ----------------------------------------------------
    
    @IBAction func btnBackTapped(_ sender: Any) {
        let parentVC = self.parent as! TabViewController
        parentVC.btnTabTapped(parentVC.btnTabs[TabBarOptions.Home.rawValue])
    }
    
    @IBAction func btnSpendCoinsTapped(_ sender: Any) {
        let parentVC = self.parent as! TabViewController
        parentVC.btnTabTapped(parentVC.btnTabs[TabBarOptions.Store.rawValue])
    }
    
    @IBAction func btnTransferTapped(_ sender: Any) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: FriendsViewController.className) as! FriendsViewController
        destination.friendListType = FriendsList.TransferCoins
        self.parent?.navigationController?.pushViewController(destination, animated: true)
    }
}

extension WalletViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.className) as! WalletTableViewCell
        cell.selectionStyle = .none
        cell.walletDetail = walletArray[indexPath.row]
        return cell
    }
}

//extension WalletViewController : WalletCoinsDelegate {
//    
//    func walletCoins() {
//      btnBack.isHidden = false
//    }
//}
