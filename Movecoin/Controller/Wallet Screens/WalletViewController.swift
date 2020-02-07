//
//  WalletViewController.swift
//  Movecoin
//
//  Created by eww090 on 16/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit


class WalletViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var tblWallet: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAmount: UIButton!
    @IBOutlet weak var btnSpendCoins: UIButton!
    @IBOutlet weak var btnTransfer: UIButton!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
   
    lazy var currentPage = 1
    lazy var isFetchingNextPage = false
    lazy var walletHistory: [WalletData] = []
    var walletType = WalletViewType.Wallet
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeUI(parentView: self.viewParent)
        self.setUpView()
        self.setupFont()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationBarSetUp(hidesBackButton: true)
        webserviceforWalletHistory(refresh: true)
        
        switch walletType {
        case .Coins:
//            btnBack.isHidden = false
            let leftBarButton = UIBarButtonItem(image: UIImage(named: "arrow-left"), style: .plain, target: self, action: #selector(btnBackTapped))
            self.parent?.navigationItem.leftBarButtonItems = [leftBarButton]
            break
         case .Wallet:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationBarSetUp()
        walletType = .Wallet
        self.parent?.navigationItem.leftBarButtonItems?.removeAll()
        self.parent?.navigationItem.rightBarButtonItems?.removeAll()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Localize.currentLanguage() == Languages.Arabic.rawValue {
            btnSpendCoins.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
            btnTransfer.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
            btnAmount.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
        }
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        tblWallet.delegate = self
        tblWallet.dataSource = self
        tblWallet.tableFooterView = UIView.init(frame: CGRect.zero)
        tblWallet.estimatedRowHeight = 65
        tblWallet.rowHeight = UITableView.automaticDimension
    }
   
    func setupFont(){
        lblTitle.font = UIFont.semiBold(ofSize: 28)
        btnAmount.titleLabel?.font = UIFont.semiBold(ofSize: 33)
        btnTransfer.titleLabel?.font = UIFont.bold(ofSize: 17)
        btnSpendCoins.titleLabel?.font = UIFont.bold(ofSize: 17)
    }
    
    func fetchNextPage() {
        self.isFetchingNextPage = true
        currentPage += 1
        webserviceforWalletHistory()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @objc func btnBackTapped() {
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

// ----------------------------------------------------
//MARK:- --------- Tableview Delegate Methods ---------
// ----------------------------------------------------

extension WalletViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.className) as! WalletTableViewCell
        cell.selectionStyle = .none
        cell.walletDetail = walletHistory[indexPath.row]
        localizeUI(parentView: cell.contentView)
        return cell
    }
}


// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension WalletViewController {
    
    func webserviceforWalletHistory(refresh : Bool = false){

            var strParam = String()
            
            guard let id = SingletonClass.SharedInstance.userData?.iD else {
                return
            }
           
            strParam = NetworkEnvironment.baseURL + ApiKey.coinsHistory.rawValue + id + "/\(currentPage)"
          
            UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
                print(json)
            
                self.isFetchingNextPage = false
                
                if status{
                    let walletModel = WalletResponseModel(fromJson: json)
                    DispatchQueue.main.async {
                      if refresh {
//                            self.refreshControl.endRefreshing()
                            self.walletHistory = walletModel.walletData
                        } else {
                            if walletModel.walletData.count > 0 {
                                self.walletHistory.append(contentsOf: walletModel.walletData)
                            }else{
                                self.isFetchingNextPage = true
                            }
                        }
                        self.tblWallet.reloadData()
                        self.btnAmount.setTitle(walletModel.coins, for: .normal)
                        SingletonClass.SharedInstance.userData?.coins = walletModel.coins
                    }
                }else{
                    UtilityClass.showAlertOfAPIResponse(param: res)
                }
            }
        }
}


//extension WalletViewController : WalletCoinsDelegate {
//    
//    func walletCoins() {
//      btnBack.isHidden = false
//    }
//}
