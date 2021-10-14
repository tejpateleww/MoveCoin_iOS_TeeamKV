//
//  TotalRedeemVC.swift
//  Movecoins
//
//  Created by Hiral's iMac on 25/11/20.
//  Copyright © 2020 eww090. All rights reserved.
//

import UIKit

struct dummyData {
    var date = String()
    var amount = String()
    
    init(date:String,amount:String) {
        self.date = date
        self.amount = amount
    }
}

class TotalRedeemVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tblRedeem: UITableView!
    
    //MARK: FileGlobals
    var refreshRedeem = UIRefreshControl()
    var arrRedeemList = [RedeemLog]()
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefresh()
        webserviceCallForRedeemList()
        
        self.title = "Total Redeem".localized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(title: "Total Redeem".localized)
    }
    
    //MARK: custom methods
    func setupRefresh(){
        tblRedeem.refreshControl = refreshRedeem
        refreshRedeem.tintColor = .white
        refreshRedeem.addTarget(self, action: #selector(refreshTableRedeem), for: .valueChanged)
    }
    @objc func refreshTableRedeem(){
        webserviceCallForRedeemList()
    }
    
    func webserviceCallForRedeemList()
    {
        let profileData = ProfileData()
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }

        profileData.user_id = id
        UserWebserviceSubclass.rewardRedeemList(profileDataModel: profileData) { (json, status, res) in
            self.refreshRedeem.endRefreshing()

            if status{
                let redeemListData = RedeemList(fromJson: json)
                self.arrRedeemList = redeemListData.redeemLog
                DispatchQueue.main.async {
                    self.tblRedeem.reloadData()
                }
            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}

//MARK: tableview Delegate-Datasource
extension TotalRedeemVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(arrRedeemList.count == 0)
        {
            return 1
        }
        return arrRedeemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(arrRedeemList.count == 0)
        {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.backgroundColor = .clear
            cell.textLabel?.text = "No data found".localized
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.regular(ofSize: 30)
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RedeemCell", for: indexPath) as! RedeemCell
            let obj = arrRedeemList[indexPath.row]
            let date = UtilityClass.changeDateFormateFrom(dateString: obj.createdAt, fromFormat: DateFomateKeys.api, withFormat: DateFomateKeys.apiDOB)
            cell.lblDate.text = date
            cell.lblAmount.text = "\(obj.sar ?? "0") " + "SAR".localized
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return arrRedeemList.count > 0 ? 70 : tableView.frame.height
    }
}

//MARK: Tableview Cell
class RedeemCell : UITableViewCell{
    
    @IBOutlet weak var lblDate: LocalizLabel!{didSet{ lblDate.font = FontBook.Regular.of(size: 18.0) }  }
    @IBOutlet weak var lblAmount: UILabel!{didSet{ lblAmount.font = FontBook.Bold.of(size: 16.0) }  }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
