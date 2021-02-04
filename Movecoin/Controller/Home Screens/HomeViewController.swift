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
import FirebaseAnalytics

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
    
    lazy var queryDate = String()
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // For apple login, alert for complete profile
        if let phoneNumber = SingletonClass.SharedInstance.userData?.phone {
            if phoneNumber.isEmpty {
                UtilityClass.showAlertWithTwoButtonCompletion(title: kAppName, Message: "For better performance please complete your profile", ButtonTitle1: "OK", ButtonTitle2: "Not now") { index in
                    if index == 0 {
                        let destination = self.storyboard?.instantiateViewController(withIdentifier: EditProfileViewController.className) as! EditProfileViewController
                        self.parent?.navigationController?.pushViewController(destination, animated: true)
                        
                    } else if index == 1 {
                        print("")
                    }
                }
            }
        }
        
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
        Analytics.logEvent("HomeScreen", parameters: nil)

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
            
            // Client Remove this
            
//            if let friendCount = Int(lblFriends.text ?? "0") {
//                if friendCount > 1 {
//                    lblTitleFriends.text = "Friends".localized
//                } else {
//                    lblTitleFriends.text = "Friend".localized
//                }
//            }
            
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
            
            
            guard var lastUpdatedStepsAt = SingletonClass.SharedInstance.lastUpdatedStepsAt else { return }
            if lastUpdatedStepsAt.isBlank {
                lastUpdatedStepsAt = Date().ToLocalStringWithFormat(dateFormat: DateFomateKeys.apiDOB)
            }
            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"//"h:mm a"
//            dateFormatter.calendar = NSCalendar.current
//            dateFormatter.timeZone = TimeZone(identifier: timeZone)
//            dateFormatter.locale = .current

            let statDate = UtilityClass.getDate(dateString: lastUpdatedStepsAt, dateFormate: DateFomateKeys.apiDOB,currentDateFormat: DateFomateKeys.apiDOB)// as? Date else {return}//dateFormatter.date(from: lastUpdatedStepsAt) else { return  }
            print("Start Date : \(statDate.getFormattedDate(dateFormate: DateFomateKeys.api))")

            let now = UtilityClass.getTodayFromServer()
            
            print("Now Date : \(now.getFormattedDate(dateFormate: DateFomateKeys.api))")

            let days = now.days(from: statDate)//interval(ofComponent: .day, fromDate: statDate)//now.startOfDay.yesterday.interval(ofComponent: .day, fromDate: statDate )
            if days >= 1 {
                getRemainingStepsFromHealthKit { (steps) in
                    print("Previous Steps : ",steps)
                    
                    if Int(steps) > 0 {
                        self.webserviceforConvertStepToCoin(stepsCount: String(Int(steps)))
                        print("IF")

                    }
                }
            }
            else{
                self.getTodaysSteps()
                print("ELSE")
            }
        } else {
            print("Health Kit Data is Not Available")
        }
    }
    
    fileprivate func getTodaysSteps() {
        
        self.getTodaysStepsFromHealthKit { (steps) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                var tempSteps = steps
                print("Today's Steps : ",steps)
                self.lblTodaysStepCount.text = String(Int(steps))
                SingletonClass.SharedInstance.todaysStepCountInitial = Int(steps)
                SingletonClass.SharedInstance.todaysStepCount = self.lblTodaysStepCount.text
                #if targetEnvironment(simulator)
                tempSteps = 5000
                #endif
                if Int(tempSteps) > 0 {
               
                    self.webserviceforUpdateStepsCount(stepsCount: String(Int(tempSteps)), dateStr: self.queryDate)
                }
                self.startCountingSteps()
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
        print("Health Kit Data is Available : \(isEnabled)")
        return isEnabled
    }
    
    func startCountingSteps(){
        if CMPedometer.isStepCountingAvailable(){
            
//            pedoMeter.startUpdates(from: Date()) { (data, error) in
            pedoMeter.startUpdates(from: UtilityClass.getTodayFromServer()) { (data, error) in
                print(data ?? 0)
                guard let activityData = data else {
                    return
                }
                DispatchQueue.main.async {
                    let lastUpdatedDate = UtilityClass.getDateFromDateString(dateString: SingletonClass.SharedInstance.lastUpdatedStepsAt ?? Date().ToLocalStringWithFormat(dateFormat: "yyyy-MM-dd"))
                    let currentDateString = Date().ToLocalStringWithFormat(dateFormat: "yyyy-MM-dd")
                    let currentDate = UtilityClass.getDateFromDateString(dateString: currentDateString)
                    
                    if lastUpdatedDate == currentDate {
                        if let counts = SingletonClass.SharedInstance.todaysStepCountInitial {
                            let total = counts + activityData.numberOfSteps.intValue
                            self.lblTodaysStepCount.text = "\(total)"
                            SingletonClass.SharedInstance.todaysStepCount = self.lblTodaysStepCount.text
                            print("Today's total steps :\(total)")
                        }else {
                            print("Today's previous steps are not there  : \(activityData.numberOfSteps.stringValue)")
                            self.lblTodaysStepCount.text = activityData.numberOfSteps.stringValue
                            SingletonClass.SharedInstance.todaysStepCount = self.lblTodaysStepCount.text
                        }
                    } else {
                        print("date is different : \(activityData.numberOfSteps.stringValue)")
                        self.lblTodaysStepCount.text = activityData.numberOfSteps.stringValue
                        SingletonClass.SharedInstance.todaysStepCount = self.lblTodaysStepCount.text
                    }
//                    if let counts = SingletonClass.SharedInstance.todaysStepCountInitial {
//                        let total = counts + activityData.numberOfSteps.intValue
//                        self.lblTodaysStepCount.text = "\(total)"
//                        SingletonClass.SharedInstance.todaysStepCount = self.lblTodaysStepCount.text
//                        print("Total:\(total)")
//                    }else {
//                        self.lblTodaysStepCount.text = activityData.numberOfSteps.stringValue
//                        SingletonClass.SharedInstance.todaysStepCount = self.lblTodaysStepCount.text
//                    }
                    
                    self.webserviceforAPPInit()
                }
            }
       	 }
    }
    
    
    func webserviceforAPPInit(){
        
        var strParam = String()
        
        strParam = NetworkEnvironment.baseURL + ApiKey.Init.rawValue + kAPPVesion + "/Ios/\(SingletonClass.SharedInstance.userData?.iD ?? "")"
        
        UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
            print(status)
            if status{
                let initResponseModel = InitResponse(fromJson: json)
                SingletonClass.SharedInstance.serverTime = initResponseModel.serverTime
                let now = UtilityClass.getTodayFromServer()
                let startOfDay = Calendar.current.startOfDay(for: now)
                self.queryDate = "\(startOfDay.getFormattedDate(dateFormate: DateFomateKeys.api)) \(now.getFormattedDate(dateFormate: DateFomateKeys.api))"
                self.webserviceforUpdateStepsCount(stepsCount: self.lblTodaysStepCount.text ?? "0", dateStr: self.queryDate)

            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func getTodaysStepsFromHealthKit(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = UtilityClass.getTodayFromServer()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        self.queryDate = "\(startOfDay.getFormattedDate(dateFormate: DateFomateKeys.api)) \(now.getFormattedDate(dateFormate: DateFomateKeys.api))"
        
        print("-------------------------------------")
        print("-- EndDate in Local : \(now.getFormattedDate(dateFormate: DateFomateKeys.api) )")
        print("-- StartDate in LocalToUTC : \(startOfDay.getFormattedDate(dateFormate: DateFomateKeys.api))")
        print("-------------------------------------")
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                print(error?.localizedDescription ?? "-")
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        healthStore.execute(query)
    }
    
    func getRemainingStepsFromHealthKit(completion: @escaping (Double) -> Void) {
        guard let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return  completion(0.0) }
        
        var lastUpdatedDate = UtilityClass.getDate(dateString: SingletonClass.SharedInstance.serverTime ?? Date().ToLocalStringWithFormat(dateFormat: "yyyy-MM-dd"), dateFormate: DateFomateKeys.api)//Date()
        let now = UtilityClass.getTodayFromServer()
        
        guard let lastUpdatedStepsAt = SingletonClass.SharedInstance.lastUpdatedStepsAt else { return }
        if lastUpdatedStepsAt.isBlank {
            completion(0.0)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"//"h:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = .current
        
        var statDate = dateFormatter.date(from: lastUpdatedStepsAt)
        let days = now.days(from: statDate ?? Date())//now.startOfDay.yesterday.interval(ofComponent: .day, fromDate: statDate ?? Date())
        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())
        if days > 7 {
            statDate = lastWeekDate?.startOfDay ?? Date()
        }
        lastUpdatedDate = lastUpdatedDate.startOfDay - 1

        print("-------------------------------------")
        print("-- EndDate in Local : \(statDate?.getFormattedDate(dateFormate: DateFomateKeys.api) ?? "-")")
        print("-- StartDate in LocalToUTC : \(lastUpdatedDate.getFormattedDate(dateFormate: DateFomateKeys.api))")
        print("-------------------------------------")
        
        let predicate = HKQuery.predicateForSamples(withStart: statDate, end: lastUpdatedDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print(error?.localizedDescription ?? "error while fetching steps")
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
        
//        guard let lastDate = SingletonClass.SharedInstance.lastUpdatedStepsAt else {
//            return
//        }
        
        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())
        guard let lastUpdatedStepsAt = SingletonClass.SharedInstance.lastUpdatedStepsAt else { return }
        
        if lastUpdatedStepsAt.isBlank {
        }
        var statDate = UtilityClass.getDate(dateString: lastUpdatedStepsAt, dateFormate: DateFomateKeys.apiDOB, currentDateFormat: DateFomateKeys.apiDOB)
        let now = UtilityClass.getTodayFromServer()
        let days = now.days(from: statDate )//now.startOfDay.yesterday.interval(ofComponent: .day, fromDate: statDate ?? Date())
        
        if days > 7 {
            statDate = lastWeekDate?.startOfDay ?? Date()
        }
        
        let model = ConvertStepsToCoinModel()
        model.previous_date = statDate.getFormattedDate(dateFormate: DateFomateKeys.apiDOB)//ToLocalStringWithFormat(dateFormat: DateFomateKeys.apiDOB)
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
    
    func webserviceforUpdateStepsCount(stepsCount : String, dateStr : String){
        
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
        var strParam = String()
//        let deviceName = UIDevice.current.name
        var uid = "uuid"
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            print(uuid)
            uid = uuid
        }
        
        strParam = NetworkEnvironment.baseURL + ApiKey.updateSteps.rawValue + id + "/\(stepsCount)/\(uid)/\(dateStr)"
        
        guard let urlString = strParam.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        
        UserWebserviceSubclass.getAPI(strURL: urlString) { (json, status, res) in
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


