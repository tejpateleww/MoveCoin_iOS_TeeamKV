//
//  ViewController.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import CoreMotion
import HealthKit
import KDCircularProgress

protocol FlipToMapDelegate {
    func flipToMap()
}

class HomeViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblTitleTotalSteps: LocalizLabel!
    @IBOutlet weak var lblTitleCoins: LocalizLabel!
    @IBOutlet weak var lblTitleInviteFriends: LocalizLabel!
    @IBOutlet weak var lblTitleFriends: LocalizLabel!
    
    @IBOutlet weak var lblTitleTodays: LocalizLabel!
    @IBOutlet weak var lblTitleTotalStep: LocalizLabel!
    
    @IBOutlet weak var lblTotalSteps: UILabel!
    @IBOutlet weak var lblCoins: UILabel!
    @IBOutlet weak var lblInviteFriends: UILabel!
    @IBOutlet weak var lblFriends: UILabel!
    
    @IBOutlet weak var lblMember: LocalizLabel!
    @IBOutlet weak var lblDescription: LocalizLabel!
    
    @IBOutlet weak var lblTodaysStepCount: UILabel!
    @IBOutlet weak var circularProgress: KDCircularProgress!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var delegateFlip : FlipToMapDelegate!
    lazy var pedoMeter = CMPedometer()
    let healthStore = HKHealthStore()
    
    var userData = SingletonClass.SharedInstance.userData
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupFont()
        healthKitData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.circularProgress.animate(fromAngle: 0, toAngle: 279, duration: 3, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBarSetUp(hidesBackButton: true)
        setUpNavigationItems()
        self.updateMylocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        webserviceForUserDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.parent?.navigationItem.leftBarButtonItems?.removeAll()
        self.parent?.navigationItem.setRightBarButton(nil, animated: true)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setupFont(){
        
        lblTitleCoins.font = UIFont.regular(ofSize: 17)
        lblTitleFriends.font = UIFont.regular(ofSize: 17)
        lblTitleTotalSteps.font = UIFont.regular(ofSize: 17)
        lblTitleInviteFriends.font = UIFont.regular(ofSize: 17)
        lblTitleTodays.font = UIFont.regular(ofSize: 23)
        lblTitleTotalSteps.font = UIFont.regular(ofSize: 16)
        
        lblCoins.font = UIFont.semiBold(ofSize: 24)
        lblFriends.font = UIFont.semiBold(ofSize: 24)
        lblTotalSteps.font = UIFont.semiBold(ofSize: 24)
        lblInviteFriends.font = UIFont.semiBold(ofSize: 24)
        
        lblDescription.font = UIFont.semiBold(ofSize: 25)
        lblMember.font = UIFont.light(ofSize: 13)
        
        self.viewParent.semanticContentAttribute = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .forceRightToLeft : .forceLeftToRight
    }
    
    func setUpNavigationItems(){
        _ = UIBarButtonItem(image: UIImage(named: "upgrad-icon"), style: .plain, target: self, action: #selector(btnUpgradeTapped))
        //        self.parent?.navigationItem.setLeftBarButtonItems([leftBarButton], animated: true)
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "flip-icon"), style: .plain, target: self, action: #selector(btnFlipTapped))
        self.parent?.navigationItem.setRightBarButtonItems([rightBarButton], animated: true)
    }
    
    func animateCircle(){
        circularProgress.animate(fromAngle: 0, toAngle: 279, duration: 5) { completed in
            if completed {
                print("Completed")
            } else {
                print("Interrupted")
            }
        }
    }
    
    @objc func btnUpgradeTapped(){
        
    }
    
    @objc func btnFlipTapped(){
        self.delegateFlip.flipToMap()
    }
    
    func setupHomeData(){
        if let user = userData {
            lblCoins.text = user.coins
            lblFriends.text = user.friends
            lblInviteFriends.text = user.inviteFriends
            lblTotalSteps.text = user.steps
            
            let membership = Membership(rawValue: Int(user.memberType) ?? 1)
            switch membership {
            case .Silver:
                imgLogo.image = UIImage.gifImageWithName("Silver-package")
            case .Gold:
                imgLogo.image = UIImage.gifImageWithName("Gold-package")
            case .Platinum:
                imgLogo.image = UIImage.gifImageWithName("Platinum-package")
            case .none:
                return
            }
        }
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Steps Count Methods ---------
    // ----------------------------------------------------
    
    func healthKitData(){
        if checkAuthorization() {
            
            getRemainingSteps { (steps) in
                print("Previous Steps : ",steps)
                
                if Int(steps) > 0 {
                    self.webserviceforConvertStepToCoin(stepsCount: String(Int(steps)))
                }else{
                    self.getTodaysSteps()
                }
            }
        }
    }
    
    func checkAuthorization() -> Bool {
        // Default to assuming that we're authorized
        var isEnabled = true
        
        // Do we have access to HealthKit on this device?
        if HKHealthStore.isHealthDataAvailable()
        {
            // We have to request each data type explicitly
            let steps = NSSet(object: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) ?? 0)
            
            // Now we can request authorization for step count data
            healthStore.requestAuthorization(toShare: nil, read: steps as? Set<HKObjectType>) { (success, error) -> Void in
                isEnabled = success
            }
        }
        else
        {
            isEnabled = false
        }
        
        return isEnabled
    }
    
    func startCountingSteps(){
        if CMPedometer.isStepCountingAvailable(){
            
            pedoMeter.startUpdates(from: Date()) { (data, error) in
                print(data ?? 0)
                guard let activityData = data else {
                    return
                }
                DispatchQueue.main.async {
                    if let counts = SingletonClass.SharedInstance.todaysStepCountInitial {
                        let total = counts + activityData.numberOfSteps.intValue
                        self.lblTodaysStepCount.text = "\(total)"
                        SingletonClass.SharedInstance.todaysStepCount = self.lblTodaysStepCount.text
                        print("Total:\(total)")
                    }else {
                        self.lblTodaysStepCount.text = activityData.numberOfSteps.stringValue
                        SingletonClass.SharedInstance.todaysStepCount = self.lblTodaysStepCount.text
                    }
                    self.webserviceforUpdateStepsCount(stepsCount: self.lblTodaysStepCount.text ?? "0")
                }
            }
        }
    }
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                print(error?.localizedDescription)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        healthStore.execute(query)
    }
    
    func getRemainingSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var startOfDay = Date()
        let now = Date()
        
        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        guard let lastUpdatedStepsAt = SingletonClass.SharedInstance.lastUpdatedStepsAt else { return }
        if lastUpdatedStepsAt.isBlank { return }
        let statDate = dateFormatter.date(from: lastUpdatedStepsAt)!
        
        let days = now.yesterday.interval(ofComponent: .day, fromDate: statDate)
        if days >= 7 {
            startOfDay = lastWeekDate.startOfDay
        } else {
            startOfDay = statDate.startOfDay
        }
        let endDate = now.yesterday.endOfDay
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print(error?.localizedDescription)
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        healthStore.execute(query)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnCoinsTapped(_ sender: Any) {
        let parentVC = self.parent as! TabViewController
        parentVC.delegateWalletCoins = parentVC
        parentVC.delegateWalletCoins.walletCoins()
        //        parentVC.btnTabTapped(parentVC.btnTabs[TabBarOptions.Wallet.rawValue])
    }
}

// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension HomeViewController {
    
    func webserviceForUserDetails(){
        
        //        UtilityClass.showHUD()
        
        let requestModel = UserDetailModel()
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
        requestModel.UserID = id
        
        UserWebserviceSubclass.userDetails(userDetailModel: requestModel){ (json, status, res) in
            
            //            UtilityClass.hideHUD()
            
            if status {
                let responseModel = LoginResponseModel(fromJson: json)
                do{
                    try UserDefaults.standard.set(object: responseModel.data, forKey: UserDefaultKeys.kUserProfile)
                    SingletonClass.SharedInstance.userData = responseModel.data
                    self.userData = responseModel.data
                    self.setupHomeData()
                    //                    AppDelegateShared.notificationEnableDisable(notification: self.userData?.notification ?? "0")
                }catch{
                    UtilityClass.showAlert(Message: error.localizedDescription)
                }
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func webserviceforConvertStepToCoin(stepsCount : String){
        
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
        
        guard let lastDate = SingletonClass.SharedInstance.lastUpdatedStepsAt else {
            return
        }
        
        let model = ConvertStepsToCoinModel()
        model.previous_date = lastDate
        model.steps = stepsCount
        model.user_id = id
        
        UserWebserviceSubclass.convertStepsToCoin(StepToCoinModel: model) { (json, status, res) in
            print(status)
            
            if status{
                print("convert steps to coins api successfully run")
            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
            
            self.getTodaysSteps()
        }
    }
    
    func getTodaysSteps()
    {
        self.getTodaysSteps { (steps) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                print("Today's Steps : ",steps)
                self.lblTodaysStepCount.text = String(Int(steps))
                SingletonClass.SharedInstance.todaysStepCountInitial = Int(steps)
                SingletonClass.SharedInstance.todaysStepCount = self.lblTodaysStepCount.text
                
                if Int(steps) > 0 {
                    
                    self.webserviceforUpdateStepsCount(stepsCount: String(Int(steps)))
                }
                self.startCountingSteps()
            }
        }
    }
    
    func webserviceforUpdateStepsCount(stepsCount : String){
        
        var strParam = String()
        
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
        
        strParam = NetworkEnvironment.baseURL + ApiKey.updateSteps.rawValue + id + "/\(stepsCount)"
        
        UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
            print(status)
            
            if status{
                DispatchQueue.main.async {
                    self.lblTotalSteps.text = json["steps"].stringValue
                    //                SingletonClass.SharedInstance.todaysStepCount =  NSNumber(value: json["steps"].intValue)
                }
            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}


