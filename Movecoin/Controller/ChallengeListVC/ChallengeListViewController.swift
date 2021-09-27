//
//  ChallengeListViewController.swift
//  Movecoins
//
//  Created by Rahul Patel on 13/09/21.
//  Copyright © 2021 eww090. All rights reserved.
//

import UIKit

class ChallengeListViewController: UIViewController {
    @IBOutlet weak var VwTopMain: UIView!
    @IBOutlet weak var imgBanner: UIImageView!
    var arrCompletedChallengeList : [ChallengesDatum]?
    {
        didSet
        {
            self.tblPastChallenges.reloadData()
        }
    }
    var dictChallenge : Challenge?
    var responseModel : ChallengeMain?
    @IBOutlet weak var lblMainVwTitleDesc: LocalizLabel?
    @IBOutlet weak var viewMainTitle: UIView?
    @IBOutlet weak var tblPastChallenges: UITableView!
    @IBOutlet weak var lblMainVwTitle: LocalizLabel?
    @IBOutlet weak var viewMainTitleDesc: UIView?
    @IBOutlet weak var lblMainVwBottomTitle: LocalizLabel?
    @IBOutlet weak var lblMainTitle: LocalizLabel?
    @IBOutlet weak var lblFinishedChallenges: LocalizLabel?
    var bannerImage = UIImage()
    @IBOutlet weak var viewMainBottomTitle: UIView?
   
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(webserviceForChallenge), for: .valueChanged)
        refreshControl.tintColor = .blue
        return refreshControl
    }()
    let cellIdentifier = "CompletedChallengeListTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblPastChallenges.delegate = self
        self.tblPastChallenges.dataSource = self
        self.tblPastChallenges.addSubview(refreshControl)
        tblPastChallenges.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)

        self.PrepareView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.VwTopMain.semanticContentAttribute = .forceLeftToRight
        self.lblMainVwTitle?.text = "message_Share_The_Challenge".localized
        self.lblMainVwBottomTitle?.text = "message_Go_Ahead".localized
        self.lblFinishedChallenges?.text = "title_finished_Challenges".localized
        self.lblMainTitle?.text = "title_new_challenge".localized
        self.PrepareView()
        self.statusBarSetUp(backColor: .clear)
        self.lblMainTitle?.awakeFromNib()
        self.lblFinishedChallenges?.awakeFromNib()
        self.view.layoutIfNeeded()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewMainTitleDesc?.layer.cornerRadius = (viewMainTitleDesc?.frame.height ?? 0)/2
        self.viewMainTitleDesc?.layer.masksToBounds = true
        self.viewMainBottomTitle?.layer.cornerRadius = (viewMainBottomTitle?.frame.height ?? 0)/2
        self.viewMainBottomTitle?.layer.masksToBounds = true
        self.viewMainTitle?.layer.cornerRadius = (viewMainTitle?.frame.height ?? 0)/2
        self.viewMainTitle?.layer.masksToBounds = true
    }
    
    
    @IBAction func btnVwHeaderAction(_ sender: Any?) {
        
        
        let releaseDate = Date(timeIntervalSince1970: Double(dictChallenge?.remainingTimetamp ?? 0))
        if releaseDate < Date()
        {
            UtilityClass.showAlert(Message: "message_no_challenge_Active".localized)
            self.webserviceForChallenge()
            return
        }
        
        if(responseModel?.isParticipant == 1)
        {
            self.navigateToNextScreen()
        }
        else
        {
            
            guard (self.dictChallenge != nil) else {
                UtilityClass.showAlert(Message: "message_no_challenge_Active".localized)
                return
            }
            if(self.dictChallenge?.id != "")
            {
                UtilityClass.showAlertWithTwoButtonCompletion(title: kAppName, Message: "message_joinChallenge", ButtonTitle1: "OK".localized, ButtonTitle2: "Cancel".localized) { index in
                    if(index == 0)
                    {
                        self.webserviceForJoinChallenge()
                    }
                }
            }
            else
            {
                UtilityClass.showAlert(Message: "message_no_challenge_Active".localized)
            }
        }
    }
    
    func PrepareView(){
        self.webserviceForChallenge()
        lblMainVwTitle?.font = UIFont.regular(ofSize: 20)
        lblMainVwBottomTitle?.font = UIFont.regular(ofSize: 25)
        lblMainVwTitleDesc?.font = UIFont.regular(ofSize: 25)
        lblMainTitle?.font = UIFont.regular(ofSize: 25)
        self.lblFinishedChallenges?.font = UIFont.regular(ofSize: 25)
        
        self.lblMainVwTitleDesc?.text = "".localized
        self.lblMainVwBottomTitle?.text = "".localized
        self.lblMainVwTitle?.text = "".localized
        self.lblMainVwBottomTitle?.textColor = UIColor(red: 238/255, green: 198/255, blue: 150/255, alpha: 1)
        
        
        self.bannerImage = ((Localize.currentLanguage() == Languages.Arabic.rawValue) ? UIImage(named: "imgBannerEmptyArabic") : UIImage(named: "imgBannerEmptyEnglish")) ?? UIImage()

        self.imgBanner.image = self.bannerImage
        self.imgBanner.contentMode = .scaleAspectFill

    }
    func setData()
    {
        let productsURL = NetworkEnvironment.baseImageURL + (dictChallenge?.sponserImage ?? "")
        self.imgBanner.contentMode = .scaleAspectFill
        if let url = URL(string: productsURL) {
            self.imgBanner.kf.indicatorType = .activity
            self.imgBanner.kf.setImage(with: url, placeholder: self.bannerImage)
        }
//        self.lblMainVwTitleDesc?.text = dictChallenge?.sponserName ?? ""
    }
    func setEmptyData()
    {
        self.imgBanner.contentMode = .scaleAspectFill
        self.lblMainVwTitleDesc?.text = "".localized
        self.lblMainVwBottomTitle?.text = "".localized
        self.imgBanner.image = self.bannerImage
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// ----------------------------------------------------
//MARK:- --------- Tableview Methods ---------
// ----------------------------------------------------
extension ChallengeListViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCompletedChallengeList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CompletedChallengeListTableViewCell
        cell.selectionStyle = .none
        cell.dictChallenge = arrCompletedChallengeList?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}




extension ChallengeListViewController {
    
    @objc func webserviceForChallenge(){
        
        let productsURL = NetworkEnvironment.baseURL + ApiKey.getChallenge.rawValue + "/" + (SingletonClass.SharedInstance.userData?.iD ?? "0")
        ChallengWebserviceSubclass.getChallenge(strURL: productsURL){ (json, status, res) in
            self.refreshControl.endRefreshing()
            self.responseModel = nil
            self.dictChallenge = nil
            self.webserviceForCompletedChallengeList()
            if status {
                self.responseModel = ChallengeMain(fromJson: json)
                self.dictChallenge = self.responseModel?.challenge
                self.setData()
            } else {
                self.setEmptyData()

            }
        }
    }
        
    func webserviceForCompletedChallengeList(){
        
        ChallengWebserviceSubclass.getCompleteChallengeList(strURL: ""){ (json, status, res) in
            self.refreshControl.endRefreshing()
            if status {
                let completedChallengeResponseModel = CompletedChallenges(fromJson: json)
                self.arrCompletedChallengeList = completedChallengeResponseModel.challengesData
            } else {
//                self.setEmptyData()
            }
        }
    }
    
    
    func webserviceForJoinChallenge(){
        let requestModel = JoinChallenge()
        requestModel.user_id = SingletonClass.SharedInstance.userData?.iD ?? ""
        requestModel.challenge_id = self.dictChallenge?.id ?? ""
        ChallengWebserviceSubclass.joinChallenge(dictJoinChallenge: requestModel) { (json, status, res) in
            self.refreshControl.endRefreshing()
            if status {
//                self.responseModel = ChallengeMain(fromJson: json)
//                self.dictChallenge = self.responseModel?.challenge
                self.webserviceForChallenge()
                self.navigateToNextScreen()
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func navigateToNextScreen()
    {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: LeaderboardViewController.className) as! LeaderboardViewController
        controller.challengeID = dictChallenge?.id
        controller.dictChallenge = self.dictChallenge
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
