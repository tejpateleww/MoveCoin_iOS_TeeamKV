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
typealias AppHealthKitValueCompletion = ((Double?, Error?)->Void)

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
//    @IBOutlet weak var lblTitleTotalStep: LocalizLabel!
    
    @IBOutlet weak var lblTotalSteps: UILabel!
    @IBOutlet weak var lblCoins: UILabel!
    @IBOutlet weak var lblInviteFriends: UILabel!
    @IBOutlet weak var lblFriends: UILabel!
    
    @IBOutlet weak var lblMember: LocalizLabel!
    @IBOutlet weak var lblDescription: LocalizLabel!
    
    @IBOutlet weak var lblTodaysStepCount: UILabel!
    @IBOutlet weak var circularProgress: KDCircularProgress!
    
    @IBOutlet weak var vWkM: UIView!
    @IBOutlet weak var lblKm: UILabel!
    @IBOutlet weak var lblTitleKm: LocalizLabel!
    
    @IBOutlet weak var vWcal: UIView!
    @IBOutlet weak var lblCal: UILabel!
    @IBOutlet weak var lblTitleCal: LocalizLabel!
    
    let k = 0.156
    let w = 71.0 //kg

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
                
        self.setupFont()
        self.PrepareView()
        healthKitData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.circularProgress.animate(fromAngle: 0, toAngle: 279, duration: 3, completion: nil)
            self.checkIfUserDetailsAreComplete()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(getTodaysSteps), name: NotificationSetTodaysSteps, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarSetUp(hidesBackButton: true)
        setUpNavigationItems()
        self.updateMylocation()
        self.statusBarSetUp(backColor: .clear)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.logEvent("HomeScreen", parameters: nil)
        webserviceForUserDetails()
        navigationController?.navigationBar.barStyle = .default

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.parent?.navigationItem.leftBarButtonItems?.removeAll()
        self.parent?.navigationItem.setRightBarButton(nil, animated: true)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    
    fileprivate func checkIfUserDetailsAreComplete() {
        
        if let weight = userData?.weight, let height = userData?.height, let nickname = userData?.nickName{
            if weight.isBlank || height.isBlank || nickname.isBlank
            {
                let destination = self.storyboard?.instantiateViewController(withIdentifier: EditProfileViewController.className) as! EditProfileViewController
                let navController = UINavigationController(rootViewController: destination)
                navController.modalPresentationStyle = .fullScreen
                destination.profileUpdated = {
                    self.getDistanceAndCalories()
                }
                self.present(navController, animated: false, completion: nil)
            }
        }
        else
        {
            if let phoneNumber = userData?.phone{
                if phoneNumber.isBlank
                {
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
        }
    }
    
    
    func PrepareView(){
        self.vWkM.layer.cornerRadius = self.vWkM.frame.size.width/2
        self.vWkM.clipsToBounds = true
        self.vWcal.layer.cornerRadius = self.vWcal.frame.size.width/2
        self.vWcal.clipsToBounds = true
    }
    
    func setupFont(){
        
        lblTitleCoins.font = UIFont.regular(ofSize: 17)
        lblTitleFriends.font = UIFont.regular(ofSize: 17)
        lblTitleTotalSteps.font = UIFont.regular(ofSize: 17)
        lblTitleInviteFriends.font = UIFont.regular(ofSize: 17)
        lblTitleTodays.font = UIFont.regular(ofSize: 20)
        lblTitleTotalSteps.font = UIFont.regular(ofSize: 20)
        lblTodaysStepCount.font = UIFont.regular(ofSize: 27)
        lblCoins.font = UIFont.regular(ofSize: 24)
        lblFriends.font = UIFont.regular(ofSize: 24)
        lblTotalSteps.font = UIFont.regular(ofSize: 24)
        lblInviteFriends.font = UIFont.regular(ofSize: 24)
        
        lblDescription.font = UIFont.regular(ofSize: 25)
        lblMember.font = UIFont.light(ofSize: 13)
        
        lblKm.font = UIFont.regular(ofSize: 21)
        lblTitleKm.font = UIFont.regular(ofSize: 17)
        
        lblCal.font = UIFont.regular(ofSize: 21)
        lblTitleCal.font = UIFont.regular(ofSize: 17)
        
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
//                print("Completed")
            } else {
//                print("Interrupted")
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
            lblCoins.text = Float(user.coins)?.setNumberFormat()
            lblFriends.text = Int(user.friends)?.setNumberFormat()
            lblInviteFriends.text = Int(user.inviteFriends)?.setNumberFormat()
            lblTotalSteps.text = Int(user.steps)?.setNumberFormat()
            
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
            let statDate = UtilityClass.getDate(dateString: lastUpdatedStepsAt, dateFormate: DateFomateKeys.apiDOB,currentDateFormat: DateFomateKeys.apiDOB)
            
            let now = UtilityClass.getTodayFromServer()
                        
            let days = now.days(from: statDate)
            
            if days >= 1 {
                getRemainingStepsFromHealthKit { (steps) in
                    if Int(steps) > 0 {
                        self.webserviceforConvertStepToCoin(stepsCount: String(Int(steps)))
                    }
                }
            }
            else{
                self.getTodaysSteps()
            }
        } else {
            
        }
    }
    
    fileprivate func getDistanceAndCalories() {
        if let userData = SingletonClass.SharedInstance.userData {
            
            var weight = Double(userData.weight) ?? 0.0
            let height = Double(userData.height) ?? 0.0
            
            self.getTodaysWalkedRunningFromHealthKit { distance,timeInSeconds  in
                let km = distance/1000.0
                DispatchQueue.main.async {
                    self.lblKm.text = String(format: "%.2f", km)
                }
            }
            
            weight = weight*2.20
            self.calculateCaloriesUsingHeight(height: height, stepsWalked: Int(SingletonClass.SharedInstance.todaysStepCount ?? "0") ?? 0, weightInPounds: weight)
        }
    }
    
    func getAgeFromDOF(date: String) -> (Int,Int,Int) {

        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd"
        let dateOfBirth = dateFormater.date(from: date)

        let calender = Calendar.current

        let dateComponent = calender.dateComponents([.year, .month, .day], from:
        dateOfBirth!, to: Date())

        return (dateComponent.year!, dateComponent.month!, dateComponent.day!)
    }
    
    @objc func getTodaysSteps() {
        
        self.getTodaysStepsFromHealthKit { (steps) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                var tempSteps = steps
//                print("Today's Steps : ",steps)
                if((SingletonClass.SharedInstance.todaysStepCount ?? "0.00") < String(Int(steps)))
                {
                    self.lblTodaysStepCount.text = String(Int(steps).setNumberFormat())
                    SingletonClass.SharedInstance.todaysStepCountInitial = Int(steps)
                    SingletonClass.SharedInstance.todaysStepCount = String(Int(steps))//self.lblTodaysStepCount.text
                    #if targetEnvironment(simulator)
                    tempSteps = 5000
                    #endif
                    if Int(tempSteps) > 0 {
                        self.webserviceforUpdateStepsCount(stepsCount: String(Int(tempSteps)), dateStr: self.queryDate)
                    }
                    self.startCountingSteps()
                    self.getDistanceAndCalories()

                }
            }
        }
    }
    
    func checkAuthorization() -> Bool {
        // Default to assuming that we're authorized
        var isEnabled = true
        
        if HKHealthStore.isHealthDataAvailable()
        {
            let steps = NSSet(object: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) ?? 0)
            
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
            pedoMeter.startUpdates(from: UtilityClass.getTodayFromServer()) { (data, error) in
                guard let activityData = data else {
                    return
                }
                DispatchQueue.main.async {
                    // if last updated date and current date is same when open from background
                    
                    let lastUpdatedDate = UtilityClass.getDateFromDateString(dateString: SingletonClass.SharedInstance.lastUpdatedStepsAt ?? Date().ToLocalStringWithFormat(dateFormat: "yyyy-MM-dd"))
                    let currentDateString = Date().ToLocalStringWithFormat(dateFormat: "yyyy-MM-dd")
                    let currentDate = UtilityClass.getDateFromDateString(dateString: currentDateString)
                    if lastUpdatedDate == currentDate {
                        if let counts = SingletonClass.SharedInstance.todaysStepCountInitial {
                            let total = counts + activityData.numberOfSteps.intValue
                            self.lblTodaysStepCount.text = "\(total.setNumberFormat())"
                            SingletonClass.SharedInstance.todaysStepCount = "\(total)"//self.lblTodaysStepCount.text
                        }else {
                            self.lblTodaysStepCount.text = Int(activityData.numberOfSteps.stringValue)?.setNumberFormat()
                            SingletonClass.SharedInstance.todaysStepCount = activityData.numberOfSteps.stringValue//self.lblTodaysStepCount.text
                        }
                    } else {
                        self.lblTodaysStepCount.text = Int(activityData.numberOfSteps.stringValue)?.setNumberFormat()
                        SingletonClass.SharedInstance.todaysStepCount = activityData.numberOfSteps.stringValue//self.lblTodaysStepCount.text
                    }
                    self.getDistanceAndCalories()
                    self.webserviceforAPPInit()
                }
            }
        }
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
//MARK:- --------- Healthkit Methods ---------
// ----------------------------------------------------

extension HomeViewController
{
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

        let predicate = HKQuery.predicateForSamples(withStart: statDate, end: lastUpdatedDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
//                print(error?.localizedDescription ?? "error while fetching steps")
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        healthStore.execute(query)
    }
    
    
    func loadCalory(since start: Date = Date().startOfDay, to end: Date = Date(), completion: @escaping AppHealthKitValueCompletion) {
            guard let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
                return
            }

            let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
                var resultCount = 0.0
                guard let result = result else {
                    completion(nil, error)
                    return
                }
                
                if let quantity = result.sumQuantity() {
                    resultCount = quantity.doubleValue(for: HKUnit.kilocalorie())
                }
                DispatchQueue.main.async {
                    completion(resultCount, nil)
                }
            }
            healthStore.execute(query)
        }
    
    
    func getTodaysStepsFromHealthKit(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = UtilityClass.getTodayFromServer()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        self.queryDate = "\(startOfDay.getFormattedDate(dateFormate: DateFomateKeys.api)) \(now.getFormattedDate(dateFormate: DateFomateKeys.api))"
    
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        healthStore.execute(query)
    }
    
    func getTodaysWalkedRunningFromHealthKit(completion: @escaping (Double,Double) -> Void) {
        guard let type = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            print("Something went wrong retriebing quantity type distanceWalkingRunning")
            return
        }
        let now = UtilityClass.getTodayFromServer()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        self.queryDate = "\(startOfDay.getFormattedDate(dateFormate: DateFomateKeys.api)) \(now.getFormattedDate(dateFormate: DateFomateKeys.api))"
        
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: [.cumulativeSum,.duration]) { _, result, error in
            guard let result = result, let sum = result.sumQuantity(),let time = result.duration() else {
                completion(0.0,0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.meter()),time.doubleValue(for: HKUnit.second()))
        }
        healthStore.execute(query)
    }
    func getTodaysHeightFromHealthKit(completion: @escaping (Double) -> Void) {
        guard let heightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height) else
        {
            print("Something went wrong retriebing quantity type height")
            return
        }
        
        let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.last as? HKQuantitySample//, let height = result.quantity as? HKQuantity
            {
                print("Height => \(result.quantity)")
                completion(result.quantity.doubleValue(for: HKUnit.meter()))
            }else{
                print("OOPS didnt get height error => \(error?.localizedDescription ?? "")")
                completion(0.0)
            }
        }
        self.healthStore.execute(query)
        
    }
    
    func getTodaysWeightFromHealthKit(completion: @escaping (Double) -> Void) {
        guard let weightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass) else
        {
            print("Something went wrong retriebing quantity type bodyMass")
            return
        }
        let query = HKSampleQuery(sampleType: weightType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.last as? HKQuantitySample{//, let weight = result.quantity as? HKQuantity{
                print("Weight => \(result.quantity)")
                completion(result.quantity.doubleValue(for: HKUnit.gram()))
            }else{
                print("OOPS didnt get Weight error => \(error?.localizedDescription ?? "")")
                completion(0.0)
            }
        }
        self.healthStore.execute(query)
        
    }
    
}

// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension HomeViewController {
    
    func webserviceForUserDetails(){
                
        let requestModel = UserDetailModel()
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
        requestModel.UserID = id
        
        
        UserWebserviceSubclass.userDetails(userDetailModel: requestModel){ (json, status, res) in
                    
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
//                print("convert steps to coins api successfully run")
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
            
            if((SingletonClass.SharedInstance.initResponse?.challenge.count ?? 0) > 0)
            {
                self.webserviceforUpdateStepsForChallenge(stepsCount: SingletonClass.SharedInstance.todaysStepCount ?? "0", challengeID: SingletonClass.SharedInstance.initResponse?.challenge.first?.challengeId ?? "0")
            }
            
            if status{
                DispatchQueue.main.async {
                    self.lblTotalSteps.text = Int(json["steps"].stringValue)?.setNumberFormat()
                    //                SingletonClass.SharedInstance.todaysStepCount =  NSNumber(value: json["steps"].intValue)
                }
            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    
    func webserviceforUpdateStepsForChallenge(stepsCount : String, challengeID : String){
        
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
        var strParam = String()
   
        strParam = id + "/\(stepsCount)/\(challengeID)"
        
        guard let urlString = strParam.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        
        ChallengWebserviceSubclass.updateStepsForChallenge(strURL: urlString) { (json, status, res) in
            print(status)
            
            if status{
//                DispatchQueue.main.async {
//                    if let leaderboardVC = UIApplication.topViewController() as? LeaderboardViewController
//                    {
//                        leaderboardVC.webServiceCallForChallengeDetails()
//                    }
//                    self.lblTotalSteps.text = json["steps"].stringValue
                    //                SingletonClass.SharedInstance.todaysStepCount =  NSNumber(value: json["steps"].intValue)
//                }
            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    @objc func webserviceforAPPInit(){
        
        var strParam = String()
        
        strParam = NetworkEnvironment.baseURL + ApiKey.Init.rawValue + kAPPVesion + "/Ios/\(SingletonClass.SharedInstance.userData?.iD ?? "")"
        
        UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
//            print(status)
            if status{
                let initResponseModel = InitResponse(fromJson: json)
                SingletonClass.SharedInstance.serverTime = initResponseModel.serverTime
                let now = UtilityClass.getTodayFromServer()
                let startOfDay = Calendar.current.startOfDay(for: now)
                self.queryDate = "\(startOfDay.getFormattedDate(dateFormate: DateFomateKeys.api)) \(now.getFormattedDate(dateFormate: DateFomateKeys.api))"
                self.webserviceforUpdateStepsCount(stepsCount: self.lblTodaysStepCount.text?.replacingOccurrences(of: ",", with: "") ?? "0", dateStr: self.queryDate)
            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}


extension HomeViewController
{
    func calculateCalories(distance : Double?, time : Double?)
    {
        let speed = (distance ?? 0.00)/(time ?? 0.00) //meter per minute
        let vo2 = (k * speed) + 0 + 3.5
        let calories1 = ((vo2 * w)/1000) * 5 //kcal/min
        let totalCalories = calories1 * (time ?? 0.0) //kcal
        DispatchQueue.main.async {
            self.lblCal.text = String(format: "%.2f", totalCalories )
        }
    }
    
    func calculateCaloriesUsingHeight(height : Double, stepsWalked : Int, weightInPounds : Double)
    {
        let x = 0.65 * weightInPounds
        let userWalkedInMiles = (Double(stepsWalked) * (height * 0.413))/160934.4
        let calories = userWalkedInMiles * x
        self.lblCal.text = String(format: "%.2f", calories)
    }
}
