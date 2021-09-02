//
//  NewStoreViewController.swift
//  Movecoins
//
//  Created by Imac on 14/07/21.
//  Copyright © 2021 eww090. All rights reserved.
//

import UIKit
import Kingfisher
class NewStoreViewController: UIViewController {
    
    @IBOutlet weak var VwTopMain: UIView!
    @IBOutlet weak var lblMainVwTitle: LocalizLabel!
    @IBOutlet weak var viewMainTitle: UIView?
    @IBOutlet weak var lblMainVwTitleDesc: LocalizLabel!
    @IBOutlet weak var viewMainTitleDesc: UIView?
    @IBOutlet weak var lblMainVwBottomTitle: LocalizLabel!
    @IBOutlet weak var viewMainBottomTitle: UIView?
    @IBOutlet weak var lblCatTitle: LocalizLabel!
    
    @IBOutlet weak var clnCategory: UICollectionView!
    @IBOutlet weak var tblStoreOffers: UITableView!
    @IBOutlet weak var tblStoreOffersHeight: NSLayoutConstraint!
    @IBOutlet weak var imgBanner: UIImageView!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var arrStatus = ["Everything","Health","Beauty","Clothes","Electronics"]
    var dictChallenge : Challenge?
    var responseModel : ChallengeMain?
    var arrOffers : [Offer]?
    {
        didSet
        {
            self.tblStoreOffers.reloadData()
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(webserviceForChallenge), for: .valueChanged)
        refreshControl.tintColor = .blue
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblStoreOffers.delegate = self
        self.tblStoreOffers.dataSource = self
        self.PrepareView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Navigation & Status bar setup
        self.navigationBarSetUp(title: "", backroundColor: .clear, hidesBackButton: false)
        self.statusBarSetUp(backColor: .clear)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewMainTitle?.layer.cornerRadius = (viewMainTitle?.frame.height ?? 0)/2
        self.viewMainTitle?.layer.masksToBounds = true
        self.viewMainTitleDesc?.layer.cornerRadius = (viewMainTitleDesc?.frame.height ?? 0)/2
        self.viewMainTitleDesc?.layer.masksToBounds = true
        self.viewMainBottomTitle?.layer.cornerRadius = (viewMainBottomTitle?.frame.height ?? 0)/2
        self.viewMainBottomTitle?.layer.masksToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationBarSetUp()
//        self.statusBarSetUp(backColor: .clear)
//        self.title = ""
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            if let info = object, let tblObj = info as? UITableView{
                if tblObj == self.tblStoreOffers{
                    self.tblStoreOffersHeight.constant = self.tblStoreOffers.contentSize.height
                    print(self.tblStoreOffersHeight.constant)
                    if self.tblStoreOffers.contentSize.height >= 100 {
                        self.tblStoreOffersHeight.constant = tblStoreOffers.contentSize.height
                    } else {
                        self.tblStoreOffersHeight.constant = 100
                    }
                }
            }
        }
    }
    
    func PrepareView(){
        
        self.tblStoreOffers.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        
        self.topViewHeight.constant = 180 //(UIScreen.main.bounds.size.height / 3.5)
        
        self.VwTopMain.layer.masksToBounds = true
        self.VwTopMain.layer.maskedCorners = [.layerMinXMinYCorner , .layerMinXMaxYCorner , .layerMaxXMaxYCorner , .layerMaxXMinYCorner]
        self.VwTopMain.layer.cornerRadius = 30.0
        
        lblMainVwTitle.font = UIFont.bold(ofSize: 20)
        lblMainVwTitleDesc.font = UIFont.regular(ofSize: 16)
        lblMainVwBottomTitle.font = UIFont.bold(ofSize: 20)
        lblCatTitle.font = UIFont.bold(ofSize: 26)
        
        scrollView.addSubview(refreshControl)
        
//        self.lblMainVwTitle.text = "  Share the challenge  "
        tblStoreOffers.rowHeight = UITableView.automaticDimension
        tblStoreOffers.estimatedRowHeight = 215
        //tblStoreOffers.addSubview(refreshControl)
        
        self.RegisterNIB()
        self.webserviceForChallenge()
    }
    
    func setData()
    {
        let productsURL = NetworkEnvironment.baseImageURL + (dictChallenge?.sponserImage ?? "")
        self.imgBanner.contentMode = .scaleAspectFill
        if let url = URL(string: productsURL) {
            self.imgBanner.kf.indicatorType = .activity
            self.imgBanner.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))
        }
    }
    
    
    func RegisterNIB(){
        self.clnCategory.register(UINib(nibName: StatusCollectionViewCell.className, bundle:nil), forCellWithReuseIdentifier: StatusCollectionViewCell.className)
    }
    
    @IBAction func btnVwHeaderAction(_ sender: Any?) {
        if(responseModel?.isParticipant == 1)
        {
            self.navigateToNextScreen()
        }
        else
        {
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
}

// ----------------------------------------------------
//MARK:- --------- Tableview Methods ---------
// ----------------------------------------------------
extension NewStoreViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOffers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewStoreTableViewCell.className) as! NewStoreTableViewCell
        cell.selectionStyle = .none
        cell.product = arrOffers?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: ProductDetailViewController.className) as! ProductDetailViewController
        let product = arrOffers?[indexPath.row]
        controller.productID = product?.id
        self.parent?.navigationController?.pushViewController(controller, animated: true)
        
        //        let controller = self.storyboard?.instantiateViewController(withIdentifier: LeaderboardViewController.className) as! LeaderboardViewController
        //        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
}

//MARK: - CollectionView Delegate and DataSource Methods
extension NewStoreViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusCollectionViewCell.className, for: indexPath) as! StatusCollectionViewCell
        cell.lblCategory.text = self.arrStatus[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = self.arrStatus[indexPath.item]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 20, height: collectionView.frame.height)
    }
}

extension NewStoreViewController {
    
    @objc func webserviceForChallenge(){
        
        let productsURL = NetworkEnvironment.baseURL + ApiKey.getChallenge.rawValue + "/" + (SingletonClass.SharedInstance.userData?.iD ?? "0")
        ChallengWebserviceSubclass.getChallenge(strURL: productsURL){ (json, status, res) in
            self.refreshControl.endRefreshing()
            self.webserviceForOfferList()
            if status {
                self.responseModel = ChallengeMain(fromJson: json)
                self.dictChallenge = self.responseModel?.challenge
                self.setData()
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
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
                self.responseModel = ChallengeMain(fromJson: json)
                self.dictChallenge = self.responseModel?.challenge
//                self.btnVwHeaderAction(nil)
                self.webserviceForChallenge()
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func webserviceForOfferList()
    {
        OffersWebserviceSubclass.offerList { json, status, res in
            if status {
                let response = OfferList(fromJson: json)
                self.arrOffers = response.offers
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

