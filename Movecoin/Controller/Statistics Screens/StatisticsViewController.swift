//
//  StatisticsViewController.swift
//  Movecoin
//
//  Created by eww090 on 16/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var tblStatistics: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    lazy var currentPage = 1
    lazy var isFetchingNextPage = false
    lazy var coinsConvertedList: [CoinsEarn] = []
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeUI(parentView: self.viewParent)
        self.setUpView()
        webserviceforCoinsConverted(refresh: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationBarSetUp()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        tblStatistics.delegate = self
        tblStatistics.dataSource = self
        tblStatistics.tableFooterView = UIView.init(frame: CGRect.zero)
        lblNoDataFound.isHidden = true
        lblTitle.font = UIFont.semiBold(ofSize: 21)
        lblNoDataFound.text = "You didn't have any updates yet".localized
    }
    
    func fetchNextPage() {
        self.isFetchingNextPage = true
        currentPage += 1
        webserviceforCoinsConverted()
    }
}

// ----------------------------------------------------
//MARK:- --------- Tableview Delegate Methods ---------
// ----------------------------------------------------

extension StatisticsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinsConvertedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.className) as! StatisticsTableViewCell
        cell.selectionStyle = .none
        cell.coinsEarnModel = coinsConvertedList[indexPath.row]
//        localizeUI(parentView: cell.contentView)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isFetchingNextPage){
            self.fetchNextPage()
        }
    }
}


// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension StatisticsViewController {
    
    func webserviceforCoinsConverted(refresh : Bool = false){
        
        var strParam = String()
        
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
        
        strParam = NetworkEnvironment.baseURL + ApiKey.coinsEarning.rawValue + id + "/\(currentPage)"
        
        UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
            print(json)
            
            self.isFetchingNextPage = false
            
            if status{
                let coinsModel = CoinsEarnResponseModel(fromJson: json)
                DispatchQueue.main.async {
                    if refresh {
                        //                            self.refreshControl.endRefreshing()
                        self.coinsConvertedList = coinsModel.coinsData
                    } else {
                        if coinsModel.coinsData.count > 0 {
                            self.coinsConvertedList.append(contentsOf: coinsModel.coinsData)
                        }else{
                            self.isFetchingNextPage = true
                        }
                    }
                    if self.coinsConvertedList.count > 0 {
                        self.lblNoDataFound.isHidden =  true
                    }else{
                        self.lblNoDataFound.isHidden =  false
                    }
                    self.tblStatistics.reloadData()
                }
            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
