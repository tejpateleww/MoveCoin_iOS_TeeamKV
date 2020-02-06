//
//  TotalStepsViewController.swift
//  Movecoin
//
//  Created by eww090 on 07/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class TotalStepsViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var tblTotalSteps: UITableView!
    
    @IBOutlet weak var lblTotalSteps: UILabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    lazy var currentPage = 1
    lazy var isFetchingNextPage = false
    lazy var stepsHistoryList: [StepsData] = []
    
//    lazy var refreshControl: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(refreshSteps), for: .valueChanged)
//        refreshControl.tintColor = .white
//        return refreshControl
//    }()
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        localizeUI(parentView: self.viewParent)
        self.setUpView()
        webserviceforStepsHistory(refresh: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(title: "Total Steps")
    }
  
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        tblTotalSteps.delegate = self
        tblTotalSteps.dataSource = self
//        tblTotalSteps.addSubview(refreshControl)
        tblTotalSteps.tableFooterView = UIView.init(frame: CGRect.zero)
        
        lblTotalSteps.font = UIFont.semiBold(ofSize: 24)
    }
    
    @objc func refreshSteps(){
        webserviceforStepsHistory()
    }
       
    func fetchNextPage() {
        self.isFetchingNextPage = true
        currentPage += 1
        webserviceforStepsHistory()
    }
}

// ----------------------------------------------------
// MARK: - --------- Tableview Methods ---------
// ----------------------------------------------------


extension TotalStepsViewController : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepsHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TotalStepsTableViewCell.className) as! TotalStepsTableViewCell
        cell.selectionStyle = .none
        cell.stepModel = stepsHistoryList[indexPath.row]
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

extension TotalStepsViewController {
    
    func webserviceforStepsHistory(refresh : Bool = false){

            var strParam = String()
            
            guard let id = SingletonClass.SharedInstance.userData?.iD else {
                return
            }
            if refresh{
                UtilityClass.showHUD()
            }
           
            strParam = NetworkEnvironment.baseURL + ApiKey.stepsHistory.rawValue + id + "/\(currentPage)"
          
            UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
                print(json)
                UtilityClass.hideHUD()
                self.isFetchingNextPage = false
                if status{
                    let stepsResponseModel = StepsHistoryResponseModel(fromJson: json)
                    DispatchQueue.main.async {
                        self.lblTotalSteps.text = stepsResponseModel.totalStepsCount
                      if refresh {
//                            self.refreshControl.endRefreshing()
                            self.stepsHistoryList = stepsResponseModel.stepsDataList
                        } else {
                            if stepsResponseModel.stepsDataList.count > 0 {
                                self.stepsHistoryList.append(contentsOf: stepsResponseModel.stepsDataList)
                            }else{
                                self.isFetchingNextPage = true
                            }
                        }
                        self.tblTotalSteps.reloadData()
                    }
                }else{
                    UtilityClass.showAlertOfAPIResponse(param: res)
                }
            }
        }
}
