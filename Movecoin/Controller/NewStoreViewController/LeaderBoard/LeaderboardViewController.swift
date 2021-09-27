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
    @IBOutlet weak var stackViewConatiner: UIStackView?
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView?
    
    @IBOutlet weak var viewRank: UIView!
    @IBOutlet weak var lblRank: UILabel!
    
    @IBOutlet weak var viewTotalSteps: UIView!
    @IBOutlet weak var imgBanner: UIImageView?
    @IBOutlet weak var lblNumberOfParticipants: UILabel!
    
    @IBOutlet weak var viewSteps: UIView!
    @IBOutlet weak var lblSteps: UILabel!
    
    @IBOutlet weak var tblLeaderboard: UITableView!
    @IBOutlet weak var tblLeaderboardHeight: NSLayoutConstraint?
    
    @IBOutlet weak var viewtableview: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewMainContainer: UIView?

    var dictChallengeDetails : ChallengeDetails?
    var dictChallenge : Challenge?
    var challengeID: String?
    var releaseDate: Date?
    var countdownTimer : Timer?

    var arrViews : [UIView] = []
//    var arrName : [String] = []
//    var arrStep : [String] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PrepareView()
        self.lblTime.text = ""
        self.webServiceCallForChallengeDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.stackViewConatiner?.semanticContentAttribute = .forceLeftToRight
            self.VwTopMain.semanticContentAttribute = .forceLeftToRight
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.navigationBar.tintColor = .white
                self.navigationBarSetUp(title: "Leaderboard".localized, backroundColor: .clear,foregroundColor: .white, hidesBackButton: false)
            self.statusBarSetUp(backColor: .clear)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Navigation & Status bar setup
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.tintColor = .white

    }
    
    func PrepareView(){
        self.setupUI()
        self.setupFont()
        self.RegisterNIB()
    }
    
    func setupUI(){
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
//        self.VwTopMain.semanticContentAttribute = .forceLeftToRight
//        self.tblLeaderboard.semanticContentAttribute = .forceLeftToRight

//        self.VwTopTimer.semanticContentAttribute = .forceLeftToRight
//        self.viewMainContainer?.semanticContentAttribute = .forceRightToLeft

        self.topViewHeight.constant = (UIScreen.main.bounds.size.height / 3.5)
        self.tblLeaderboard.separatorStyle = .none
        self.tblLeaderboard.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblLeaderboard.reloadData()
        
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.showsHorizontalScrollIndicator = false
        
        //self.imgRank.image = self.imgRank.image?.withRenderingMode(.alwaysTemplate)
        //self.imgRank.tintColor = UIColor.white
        //self.imgTotalSteps.image = self.imgTotalSteps.image?.withRenderingMode(.alwaysTemplate)
        //self.imgTotalSteps.tintColor = UIColor.white
        //self.imgSteps.image = self.imgSteps.image?.withRenderingMode(.alwaysTemplate)
        //self.imgSteps.tintColor = UIColor.white
        
    }
    
    func setupFont (){
        self.lblTime.font = UIFont.regular(ofSize: 15)
        self.lblRank.font = UIFont.regular(ofSize: 25)
        self.lblNumberOfParticipants.font = UIFont.regular(ofSize: 25)
        self.lblSteps.font = UIFont.regular(ofSize: 25)
    }
    
    fileprivate func setData()
    {
        self.lblRank.text = "\(dictChallengeDetails?.yourRank ?? 0)"
        self.lblNumberOfParticipants.text = "\(dictChallengeDetails?.totalParticipant ?? 0)"
        self.lblSteps.text = "\(dictChallengeDetails?.yourSteps ?? 0)"
//        self.lblTime.text = dictChallenge?.remainingTime
        releaseDate = Date(timeIntervalSince1970: Double(dictChallenge?.remainingTimetamp ?? 0))
        let productsURL = NetworkEnvironment.baseImageURL + (dictChallenge?.prizeImage ?? "")
        if let url = URL(string: productsURL) {
            self.imgBanner?.kf.indicatorType = .activity
            self.imgBanner?.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))
        }
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)

        
        tblLeaderboard.reloadData()
    }
    
    @objc func updateTime() {

        let currentDate = Date()
        let calendar = Calendar.current

        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: releaseDate! as Date)

        let hours = ((diffDateComponents.day ?? 0) * 24) + (diffDateComponents.hour ?? 0)
        let countdown = "\(hours) H : \(diffDateComponents.minute ?? 0) M : \(diffDateComponents.second ?? 0) S"
//        print(Double(dictChallenge?.remainingTimeStamp ?? 0).asString(style: .full))        // 2 hours, 46 minutes, 40 seconds

        
//        print(countdown)
        
        self.lblTime.text = "\(countdown)"

    }
    
    
    
    func RegisterNIB(){
        self.tblLeaderboard.register(UINib(nibName: LeaderboardCell.className, bundle: nil), forCellReuseIdentifier: LeaderboardCell.className)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            if let info = object, let tblObj = info as? UITableView{
                if tblObj == self.tblLeaderboard{
                    self.tblLeaderboardHeight?.constant = self.tblLeaderboard.contentSize.height
//                    print(self.tblLeaderboardHeight?.constant)
                    if self.tblLeaderboard.contentSize.height >= 100 {
                        self.tblLeaderboardHeight?.constant = self.tblLeaderboard.contentSize.height
                    } else {
                        self.tblLeaderboardHeight?.constant = 100
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
        return dictChallengeDetails?.topFiveParticipant.count ?? 0 //self.arrName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeaderboardCell.className) as! LeaderboardCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.lblRank.text = "\(indexPath.row + 1)"
        cell.viewContainer.semanticContentAttribute = .forceLeftToRight
        let obj = dictChallengeDetails?.topFiveParticipant[indexPath.row]
        cell.lblName.text = obj?.nickName
        cell.lblStep.text = obj?.steps

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
        viewtableview.alpha = 0
        
        let offerURL = NetworkEnvironment.baseURL + ApiKey.challengeDetails.rawValue + "/" + (SingletonClass.SharedInstance.userData?.iD ?? "0") + "/" + (challengeID ?? "0")
        ChallengWebserviceSubclass.getChallengeDetails(strURL: offerURL) { json, status, res in
            if status {
                self.viewtableview.alpha = 1
                self.dictChallengeDetails = ChallengeDetails(fromJson: json)
                self.setData()
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}


extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
    formatter.unitsStyle = style
    return formatter.string(from: self) ?? ""
  }
}
