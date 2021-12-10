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
    @IBOutlet weak var viewTime: UIView?

    @IBOutlet weak var tblLeaderboard: UITableView!
    @IBOutlet weak var tblLeaderboardHeight: NSLayoutConstraint?
    
    @IBOutlet weak var viewtableview: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewMainContainer: UIView?
    
    @IBOutlet weak var lblRankTitle: UILabel!
    @IBOutlet weak var lblStepsTitle: UILabel!
    @IBOutlet weak var lblNumberOfParticipantsTitle: UILabel!


    var dictChallengeDetails : ChallengeDetails?
    {
        didSet
        {
            UIView.performWithoutAnimation {
                   self.tblLeaderboard.reloadData()
            }
        }
    }
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
            self.viewTime?.semanticContentAttribute = .forceLeftToRight
            self.VwTopMain.semanticContentAttribute = .forceLeftToRight
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationBarSetUp(title: "Leaderboard".localized, backroundColor: .clear,foregroundColor: .white, hidesBackButton: false)
            let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.webServiceCallForChallengeDetails))
            self.navigationItem.rightBarButtonItems = [refresh]
            self.statusBarSetUp(backColor: .clear)
        }
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
        self.topViewHeight.constant = 210//(UIScreen.main.bounds.size.height / 3.25)
        self.imgBanner?.contentMode = .scaleAspectFill
        self.tblLeaderboard.separatorStyle = .none
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.showsHorizontalScrollIndicator = false
    }
    
    func setupFont (){
        self.lblTime.font = UIFont.regular(ofSize: 15)
        self.lblRank.font = UIFont.regular(ofSize: 20)
        self.lblNumberOfParticipants.font = UIFont.regular(ofSize: 20)
        self.lblSteps.font = UIFont.regular(ofSize: 20)
        
        self.lblRankTitle.font = UIFont.regular(ofSize: 15)
        self.lblStepsTitle.font = UIFont.regular(ofSize: 15)
        self.lblNumberOfParticipantsTitle.font = UIFont.regular(ofSize: 15)
    }
    
    fileprivate func setData()
    {
        self.lblRank.text = (dictChallengeDetails?.yourRank ?? 0).setNumberFormat()
        self.lblNumberOfParticipants.text = (dictChallengeDetails?.totalParticipant ?? 0).setNumberFormat()
        self.lblSteps.text = (dictChallengeDetails?.yourSteps ?? 0).setNumberFormat()
        releaseDate = Date(timeIntervalSince1970: Double(dictChallenge?.remainingTimetamp ?? 0))
        let productsURL = NetworkEnvironment.baseImageURL + (dictChallenge?.prizeImage ?? "")
        if let url = URL(string: productsURL) {
            self.imgBanner?.kf.indicatorType = .activity
//            self.imgBanner?.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))
            self.imgBanner?.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"), options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ], progressBlock: { receivedSize, totalSize in
                print("The total size is \(totalSize)")
            }, completionHandler: { result in
                switch result {
                   case .success(let value):
                       print("Task done for: \(value.source.url?.absoluteString ?? "")")
                   case .failure(let error):
                       print("Job failed: \(error.localizedDescription)")
                   }
            })
        }
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        let currentDate = Date()
        let calendar = Calendar.current
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: releaseDate! as Date)
        let hours = ((diffDateComponents.day ?? 0) * 24) + (diffDateComponents.hour ?? 0)
        let countdown = "\(hours) H : \(diffDateComponents.minute ?? 0) M : \(diffDateComponents.second ?? 0) S"
        if((diffDateComponents.second ?? 0) < 0){
            countdownTimer?.invalidate()
            countdownTimer = nil
            return
        }
        self.lblTime.text = "\(countdown)"
    }

    func RegisterNIB(){
        self.tblLeaderboard.register(UINib(nibName: LeaderboardCell.className, bundle: nil), forCellReuseIdentifier: LeaderboardCell.className)
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
        cell.viewContainer.semanticContentAttribute = .forceLeftToRight
        let obj = dictChallengeDetails?.topFiveParticipant[indexPath.row]
        cell.lblName.text = obj?.nickName
        cell.lblStep.text = Int(obj?.steps ?? "0")?.setNumberFormat()
        cell.lblRank.text = obj?.rank//"\(indexPath.row + 1)"r

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
    @objc func webServiceCallForChallengeDetails()
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


extension Int
{
    func setNumberFormat() -> (String)
    {
        let numberFormatterRank = NumberFormatter()
        numberFormatterRank.numberStyle = .decimal
        numberFormatterRank.locale = Locale(identifier: "en_US")
        let strRank = numberFormatterRank.string(from: NSNumber(value:self)) ?? "0.0"
        return(strRank)
    }
}



extension Float
{
    func setNumberFormat() -> (String)
    {
        let numberFormatterRank = NumberFormatter()
        numberFormatterRank.numberStyle = .decimal
        numberFormatterRank.locale = Locale(identifier: "en_US")
        let strRank = numberFormatterRank.string(from: NSNumber(value:self)) ?? "0.0"
        return(strRank)
    }
}

