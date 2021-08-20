//
//  LeaderboardViewController.swift
//  Movecoins
//
//  Created by Imac on 15/07/21.
//  Copyright © 2021 eww090. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {
    
    @IBOutlet weak var VwTopMain: UIView!
    @IBOutlet weak var VwTopTimer: UIStackView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewRank: UIView!
    @IBOutlet weak var lblRank: UILabel!
    
    @IBOutlet weak var viewTotalSteps: UIView!
    @IBOutlet weak var lblNumberOfParticipants: UILabel!
    
    @IBOutlet weak var viewSteps: UIView!
    @IBOutlet weak var lblSteps: UILabel!
    
    @IBOutlet weak var tblLeaderboard: UITableView!
    @IBOutlet weak var tblLeaderboardHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewtableview: UIView!
    @IBOutlet weak var lblTime: UILabel!
    
    var dictChallengeDetails : ChallengeDetails?
    
    var arrViews : [UIView] = []
    var arrName : [String] = []
    var arrStep : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PrepareView()
        self.webServiceCallForChallengeDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Navigation & Status bar setup
        self.navigationController?.navigationBar.isHidden = false
        self.navigationBarSetUp(title: "Leaderboard".localized, backroundColor: ThemeBlueColor, hidesBackButton: false)
        self.statusBarSetUp(backColor: ThemeBlueColor)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationBarSetUp()
        self.statusBarSetUp(backColor: .clear)
        self.title = ""
    }
    
    func PrepareView(){
        self.setupUI()
        self.setupFont()
        self.RegisterNIB()
    }
    
    func setupUI(){
        
        self.arrName = ["Test 1","Test 2","Test 3","Test 4","Test 5","Test 6","Test 7"]
        self.arrStep = ["1000","2000","3000","4000","5000","6000","7000"]
        self.arrViews = [self.viewRank , self.viewSteps , self.viewTotalSteps]
        for TempView in self.arrViews {
            TempView.layer.masksToBounds = true
            TempView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMinXMaxYCorner , .layerMaxXMaxYCorner , .layerMaxXMinYCorner]
            TempView.layer.cornerRadius = 15.0
        }
        
        self.tblLeaderboard.layer.masksToBounds = true
        self.tblLeaderboard.layer.maskedCorners = [.layerMinXMinYCorner , .layerMinXMaxYCorner , .layerMaxXMaxYCorner , .layerMaxXMinYCorner]
        self.tblLeaderboard.layer.cornerRadius = 30.0
        
        self.VwTopMain.layer.masksToBounds = true
        self.VwTopMain.layer.maskedCorners = [.layerMinXMinYCorner , .layerMinXMaxYCorner , .layerMaxXMaxYCorner , .layerMaxXMinYCorner]
        self.VwTopMain.layer.cornerRadius = 30.0
        self.VwTopMain.semanticContentAttribute = .forceLeftToRight
        self.VwTopTimer.semanticContentAttribute = .forceLeftToRight

        self.topViewHeight.constant = (UIScreen.main.bounds.size.height / 3.5)
        self.tblLeaderboard.separatorStyle = .none
        self.tblLeaderboard.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblLeaderboard.reloadData()
        
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        
//        self.imgRank.image = self.imgRank.image?.withRenderingMode(.alwaysTemplate)
//        self.imgRank.tintColor = UIColor.white
//        self.imgTotalSteps.image = self.imgTotalSteps.image?.withRenderingMode(.alwaysTemplate)
//        self.imgTotalSteps.tintColor = UIColor.white
//        self.imgSteps.image = self.imgSteps.image?.withRenderingMode(.alwaysTemplate)
//        self.imgSteps.tintColor = UIColor.white
        
    }
    
    func setupFont (){
        
        self.lblTime.font = UIFont.bold(ofSize: 15)
        self.lblRank.font = UIFont.bold(ofSize: 18)
        self.lblNumberOfParticipants.font = UIFont.bold(ofSize: 18)
        self.lblSteps.font = UIFont.bold(ofSize: 18)
        
    }
    
    fileprivate func setData()
    {
//        self.lblTime.text = dictChallengeDetails
        self.lblRank.text = "\(dictChallengeDetails?.yourRank ?? 0)"
        self.lblNumberOfParticipants.text = "\(dictChallengeDetails?.totalParticipant ?? 0)"
        self.lblSteps.text = "\(dictChallengeDetails?.yourSteps ?? 0)"
    }
    
    func RegisterNIB(){
        self.tblLeaderboard.register(UINib(nibName: LeaderboardCell.className, bundle: nil), forCellReuseIdentifier: LeaderboardCell.className)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            if let info = object, let tblObj = info as? UITableView{
                if tblObj == self.tblLeaderboard{
                    self.tblLeaderboardHeight.constant = self.tblLeaderboard.contentSize.height
                    print(self.tblLeaderboardHeight.constant)
                    if self.tblLeaderboard.contentSize.height >= 100 {
                        self.tblLeaderboardHeight.constant = self.tblLeaderboard.contentSize.height
                    } else {
                        self.tblLeaderboardHeight.constant = 100
                    }
                }
            }
        }
    }


}

// ----------------------------------------------------
//MARK:- --------- Tableview Methods ---------
// ----------------------------------------------------
extension LeaderboardViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeaderboardCell.className) as! LeaderboardCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.lblRank.text = "\(indexPath.row + 1)"
        cell.lblName.text = self.arrName[indexPath.row]
        cell.lblStep.text = self.arrStep[indexPath.row]
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension LeaderboardViewController
{
    func webServiceCallForChallengeDetails()
    {
        let offerURL = NetworkEnvironment.baseURL + ApiKey.challengeDetails.rawValue + "/" + (SingletonClass.SharedInstance.userData?.iD ?? "0")
        ChallengWebserviceSubclass.getChallengeDetails(strURL: offerURL) { json, status, res in
            if status {
                self.dictChallengeDetails = ChallengeDetails(fromJson: json)
                self.setData()
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
