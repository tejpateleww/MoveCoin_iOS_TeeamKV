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
    var arrDummy = [dummyData]()
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefresh()
        arrDummy.append(dummyData(date: "05/11/2020", amount: "70.00 SAR"))
        arrDummy.append(dummyData(date: "21/10/2020", amount: "50.00 SAR"))
        arrDummy.append(dummyData(date: "01/08/2020", amount: "150.00 SAR"))
        arrDummy.append(dummyData(date: "22/12/2019", amount: "300.00 SAR"))
        arrDummy.append(dummyData(date: "31/11/2019", amount: "200.00 SAR"))
        arrDummy.append(dummyData(date: "04/10/2019", amount: "100.00 SAR"))
        arrDummy.append(dummyData(date: "08/06/2019", amount: "10.00 SAR"))
        arrDummy.append(dummyData(date: "24/05/2020", amount: "100.00 SAR"))
        arrDummy.append(dummyData(date: "21/04/2019", amount: "50.00 SAR"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(title: "Total Redeem")
    }
    
    //MARK: custom methods
    func setupRefresh(){
        tblRedeem.refreshControl = refreshRedeem
        refreshRedeem.tintColor = .white
        refreshRedeem.addTarget(self, action: #selector(refreshTableRedeem), for: .valueChanged)
    }
    @objc func refreshTableRedeem(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.refreshRedeem.endRefreshing()
        }
    }
}

//MARK: tableview Delegate-Datasource
extension TotalRedeemVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedeemCell", for: indexPath) as! RedeemCell
        let obj = arrDummy[indexPath.row]
        cell.lblDate.text = obj.date
        cell.lblAmount.text = obj.amount
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
