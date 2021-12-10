//
//  AppDelegate.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
//import Fabric
//import Crashlytics
import FirebaseCore
import FirebaseInstanceID
import FirebaseMessaging
import SocketIO 
import CoreLocation
import CoreMotion
import FBSDKCoreKit
import HealthKit
import AVFoundation

//import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    let healthKitStore:HKHealthStore = HKHealthStore()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()

        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
//        UIFont.familyNames.forEach({ familyName in
//            let fontNames = UIFont.fontNames(forFamilyName: familyName)
//            print(familyName, fontNames)
//        })
        
//        #if DEBUG
//        //                return .developmentBaseUrl
//        self.authorizeHealthKit { (authorized,  error) -> Void in
//            if authorized {
//                print("HealthKit authorization received.")
//            }
//            else {
//                print("HealthKit authorization denied!")
//                if error != nil {
//                    print("\(error ?? NSError())")
//                }
//            }
//        }
//
//        #else
//        //                return .liveBaseUrl
//        #endif
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        // Client MoveCoins Key and Secret
        //        TWTRTwitter.sharedInstance().start(withConsumerKey: "MOCMQEYul9oCmCmYDXk8Q7nVN", consumerSecret: "Nv7qw5isiL2TrRQgQafRkJieHSbJyPnNTttaHVPKu4zEQBeXzX")
        
        let status = CMPedometer.authorizationStatus()
        print("Permission : ",status.rawValue)
        
        // For Background Task
        var bgTask = UIBackgroundTaskIdentifier(rawValue: 0)
        bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(bgTask)
        })
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        setupApplication()
        setUpNavigationBar()
//        locationPermission()
        
//        configureNotification()
        //        Fabric.with([Crashlytics.self])
        
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)
        
        return true
    }
    
    
    
    func startObservingHeightChanges() {
        
        let sampleType =  HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! as HKQuantityType
        
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil) { (query, completionHandler, error) in
            if error != nil {

                // Perform Proper Error Handling Here...
                print("*** An error occured while setting up the stepCount observer. \(error?.localizedDescription ?? "") ***")
//                abort()
            }
            else
            {
                self.heightChangedHandler(query: query, completionHandler: completionHandler, error: error as NSError?)
            }

            // Take whatever steps are necessary to update your app's data and UI
            // This may involve executing other queries
//            self.updateDailyStepCount()

            // If you have subscribed for background updates you must call the completion handler here.
            // completionHandler()
        }//HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.heightChanged)
        
        healthKitStore.execute(query)
        
        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .hourly) { (success, error) in
            if success{
                print("Enabled background delivery of weight changes")
            } else {
                if let theError = error{
                    print("Failed to enable background delivery of weight changes. ")
                    print("Error = \(theError)")
                }
            }
        }
    }
    
    
    func heightChangedHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: NSError!) {
        
        let healthStore = HKHealthStore()

        let now = UtilityClass.getTodayFromServer()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        let sample = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
//                completion(0.0)
                print(error?.localizedDescription ?? "-")
                return
            }
            self.localNotification(value: "\(sum.doubleValue(for: HKUnit.count()))")
        }
        healthStore.execute(sample)

       
        completionHandler()
    }
    
    func localNotification(value : String)
    {
        //get the notification center
        let center =  UNUserNotificationCenter.current()

        //create the content for the notification
        let content = UNMutableNotificationContent()
        
        content.title = "Today's Steps \(value)"
        content.subtitle = "Keep it up"
//        content.body = "Its lunch time at the park, please join us for a dinosaur feeding"
        content.sound = UNNotificationSound.default
        //notification trigger can be based on time, calendar or location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:2.0, repeats: false)

        //create request to display
        let request = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)

        //add request to notification center
        center.add(request) { (error) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
        
        webserviceforUpdateStepsCount(stepsCount: value)
    }
    
    
    func webserviceforUpdateStepsCount(stepsCount : String){
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let dateStr = "\(startOfDay.getFormattedDate(dateFormate: DateFomateKeys.api)) \(now.getFormattedDate(dateFormate: DateFomateKeys.api))"
        
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
        var strParam = String()
        var uid = "uuid"
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            uid = uuid
        }
        
        strParam = NetworkEnvironment.baseURL + ApiKey.updateSteps.rawValue + id + "/\(stepsCount)/\(uid)/\(dateStr)"
        
        guard let urlString = strParam.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        
        UserWebserviceSubclass.getAPI(strURL: urlString) { (json, status, res) in
            print(status)
            
        }
    }
    
    
    func authorizeHealthKit(completion: ((_ success:Bool, _ error:NSError?) -> Void)!) {
   
        // 1. Set the types you want to read from HK Store
        let healthKitTypesToRead = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount),
        ] as! [HKObjectType]
        
        // 2. Set the types you want to write to HK Store

        
        // 3. If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable() {
            let error = NSError(domain: "any.domain.com", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            
            if(completion != nil) {
                completion(false, error)
            }
            return;
        }
        
        // 4.  Request HealthKit authorization
        healthKitStore.requestAuthorization(toShare: nil, read: Set(healthKitTypesToRead)) { (success, error) in
            if( completion != nil ) {
                
                DispatchQueue.main.async {

                }
                completion(success,error as NSError?)
                
            }
        }
 
    }
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("App is in Background mode")
        SocketIOManager.shared.establishConnection()
        SocketIOManager.shared.socket.on(clientEvent: .connect) { (data, ack) in
            print ("socket connected")
        }
        print(SocketIOManager.shared.isSocketOn)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        if (((AppDelegateShared.window?.rootViewController as? UINavigationController)?.topViewController as? ChatViewController) != nil) {
            let vc = (AppDelegateShared.window?.rootViewController as? UINavigationController)?.topViewController as! ChatViewController
            vc.webserviceForChatHistory(isLoading: false)
        }
        
        // If LastUpdatedDate and Current Date is same then Main Today's steps should be 0 if it opens from background 
//        if let topViewController = UIApplication.topViewController()?.children.first as? HomeViewController {
            DispatchQueue.main.async {
                
                let lastUpdatedDate = UtilityClass.getDateFromDateString(dateString: SingletonClass.SharedInstance.lastUpdatedStepsAt ?? Date().ToLocalStringWithFormat(dateFormat: "yyyy-MM-dd"))
                let currentDateString = Date().ToLocalStringWithFormat(dateFormat: "yyyy-MM-dd")
                let currentDate = UtilityClass.getDateFromDateString(dateString: currentDateString)
                
                if lastUpdatedDate != currentDate {
//                    topViewController.getTodaysSteps()
                    SingletonClass.SharedInstance.todaysStepCount = "" // This is done because when coming from background and day is changed then this is affecting in getTodaysStepsFromHealthKit
                    self.webserviceforAPPInit()

                }
            }
//        }
    }
    
    
    func webserviceforAPPInit(){
        
        var strParam = String()
        
        strParam = NetworkEnvironment.baseURL + ApiKey.Init.rawValue + kAPPVesion + "/Ios/\(SingletonClass.SharedInstance.userData?.iD ?? "")"
        
        UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
            print(status)
            if status{
                let initResponseModel = InitResponse(fromJson: json)
                SingletonClass.SharedInstance.lastUpdatedStepsAt = initResponseModel.lastUpdateStepAt
                SingletonClass.SharedInstance.productType = initResponseModel.category
                SingletonClass.SharedInstance.coinsDiscountRelation = initResponseModel.coinsDiscountRelation
                SingletonClass.SharedInstance.serverTime = initResponseModel.serverTime
//                topViewcontroller.getTodaysSteps()
                NotificationCenter.default.post(name: NotificationSetTodaysSteps, object: nil)

            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        _ = ApplicationDelegate.shared.application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        // Add any custom logic here.
        
        //        let access = TWTRTwitter.sharedInstance().application(application, open: url, options: options)
        
        return true
    }
    
}

// ----------------------------------------------------
//MARK:- === Custom methods ======
// ----------------------------------------------------

extension AppDelegate {
    
    func setupApplication(){
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localized
        
        UIView.appearance().semanticContentAttribute = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .forceRightToLeft : .forceLeftToRight
        
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = loginStoryboard.instantiateViewController(withIdentifier: SplashViewController.className) as? SplashViewController
        let nav = UINavigationController(rootViewController: controller!)
        self.window?.rootViewController = nav
    }
    
    func setUpNavigationBar(){
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barStyle = UIBarStyle.black
        navigationBarAppearace.tintColor = UIColor.white
        
        // For "Back" text remove from navigationbar
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)
    }
    
    @objc func locationPermission() {
        
        if (CLLocationManager.authorizationStatus() == .denied) || CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .notDetermined {
            // Ask for Authorisation from the User.
            self.locationManager.requestAlwaysAuthorization()
            
            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func GoToPermission(type : StepsPermission) {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyborad.instantiateViewController(withIdentifier: PermissionAlertViewController.className) as! PermissionAlertViewController
        destination.stepsPermissionType = type
        let NavHomeVC = UINavigationController(rootViewController: destination)
        self.window?.rootViewController = NavHomeVC
    }
    
    func GoToHome() {
        // For localization
        UIView.appearance().semanticContentAttribute = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .forceRightToLeft : .forceLeftToRight
        
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyborad.instantiateViewController(withIdentifier: TabViewController.className) as! TabViewController
        let NavHomeVC = UINavigationController(rootViewController: destination)
        self.window?.rootViewController = NavHomeVC
    }
    
    func GoToOnBoard(){
        let storyborad = UIStoryboard(name: "Login", bundle: nil)
        let Login = storyborad.instantiateViewController(withIdentifier: OnBoradViewController.className) as! OnBoradViewController
        let NavHomeVC = UINavigationController(rootViewController: Login)
        self.window?.rootViewController = NavHomeVC
    }
    
    func GoToLogin() {
        
        let storyborad = UIStoryboard(name: "Login", bundle: nil)
        let Login = storyborad.instantiateViewController(withIdentifier: WelcomeViewController.className) as! WelcomeViewController
        let NavHomeVC = UINavigationController(rootViewController: Login)
        self.window?.rootViewController = NavHomeVC
    }
    
    func GoToLogout() {
        SocketIOManager.shared.closeConnection()
        // Reset UserDefaults
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        self.GoToLogin()
    }
    
    func GetTopViewController() -> UIViewController {
        return self.window!.rootViewController!
    }
    
    func loadFriendsRequest(){
        if let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController {
            if let vc : InviteViewController = (vc as? InviteViewController) {
                vc.isFromNotification = true
                vc.refreshAllFriendsList()
                
                if vc.btnFriends.isSelected {
                    vc.btnFiendFriendsTapped(vc.btnFriends as Any)
                }
            }else {
                if let inviteVC = vc.navigationController?.hasViewController(ofKind: InviteViewController.self) as? InviteViewController {
                    
                    for controller in vc.navigationController?.viewControllers ?? [] {
                        if(controller.isKind(of: InviteViewController.self)) {
                            let inviteController = controller as! InviteViewController
                            vc.navigationController?.popToViewController(inviteController, animated: true)
                            break
                        }
                    }
                    inviteVC.isFromNotification = true
                    inviteVC.refreshAllFriendsList()
                    
                } else {
                    let state = UIApplication.shared.applicationState
                    if state == .inactive {
                        NotificationCenter.default.addObserver(self, selector: #selector(loadInviteVC), name: NotificationSetHomeVC, object: nil)
                    }
                    if !vc.isKind(of: SplashViewController.self) {
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: InviteViewController.className) as! InviteViewController
                        controller.isFromNotification = true
                        vc.navigationController?.pushViewController(controller, animated: false)
                    }
                }
            }
        }
    }
    
    func loadWallet(){
        if let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController {
            
            if let vc : TabViewController = (vc as? TabViewController) {
                vc.btnTabTapped(vc.btnTabs[TabBarOptions.Wallet.rawValue])
            } else {
                for controller in vc.navigationController?.viewControllers ?? [] {
                    if(controller.isKind(of: TabViewController.self)) {
                        let tabVC = controller as! TabViewController
                        vc.navigationController?.popToViewController(tabVC, animated: true)
                        tabVC.btnTabTapped(tabVC.btnTabs[TabBarOptions.Wallet.rawValue])
                        break
                    }
                }
            }
        }
    }
    
    func acceptFriedRequestNotificationHandle(){
        if let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController {
            if let vc : FriendsViewController = (vc as? FriendsViewController) {
                
                vc.webserviceForFriendsList(isLoading: true)
            }else {
                
                let state = UIApplication.shared.applicationState
                if state == .inactive {
                    NotificationCenter.default.addObserver(self, selector: #selector(loadFriendVC), name: NotificationSetHomeVC, object: nil)
                }
                if !vc.isKind(of: SplashViewController.self) {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: FriendsViewController.className) as! FriendsViewController
                    controller.webserviceForFriendsList(isLoading: true)
                    vc.navigationController?.pushViewController(controller, animated: false)
                }
            }
        }
    }
    
    func productDetails()
    {
        if let topViewController = UIApplication.topViewController() as? ProductDetailViewController
        {
            //topViewController.webserviceForProductDetails()
            topViewController.webserviceForOfferDetails()
        }
    }
    
    @objc func loadFriendVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: FriendsViewController.className) as! FriendsViewController
        controller.webserviceForFriendsList(isLoading: true)
        (self.window?.rootViewController as? UINavigationController)?.pushViewController(controller, animated: false)
    }
    
    @objc func loadChatVC(){
        let storyboard = UIStoryboard(name: "ChatStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
        let userinfo = SingletonClass.SharedInstance.userInfo
        controller.receiverID = userinfo?["SenderID"] as? String
        (self.window?.rootViewController as? UINavigationController)?.pushViewController(controller, animated: false)
    }
    
    @objc func loadInviteVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: InviteViewController.className) as! InviteViewController
        controller.isFromNotification = true
        (self.window?.rootViewController as? UINavigationController)?.pushViewController(controller, animated: false)
    }
    
    func notificationEnableDisable(notification : String){
        if notification == "0" {
            UIApplication.shared.unregisterForRemoteNotifications()
        } else {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- Socket Methods ---------
// ----------------------------------------------------

extension AppDelegate {
    
    // Socket On Connect User
    func onSocketConnectUser() {
        SocketIOManager.shared.socketCall(for: SocketApiKeys.kConnectUser) { (json) in
            print(json)
        }
    }
    
    // Socket Emit Connect user
    func emitSocket_UserConnect(){
        let param = [
            SocketApiKeys.KUserId : SingletonClass.SharedInstance.userData?.iD ?? "" as Any
        ] as [String : Any]
        SocketIOManager.shared.socketEmit(for: SocketApiKeys.kConnectUser, with: param)
    }
    
}

// ----------------------------------------------------
//MARK:- --------- Push Notification Methods ---------
// ----------------------------------------------------

extension AppDelegate {
    
    func configureNotification() {
        
        Messaging.messaging().delegate = self
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = token {
                print("Remote instance ID token: \(result )")
                SingletonClass.SharedInstance.DeviceToken = result
                UserDefaults.standard.set(SingletonClass.SharedInstance.DeviceToken, forKey: UserDefaultKeys.kDeviceToken)
            }
        }
        notificationCenter.delegate = self
//        notificationCenter.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
//        UIApplication.shared.registerForRemoteNotifications()
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(deviceTokenString)")
        
        _ = deviceToken.map({ (data)-> String in
            return String(format: "%0.2.2hhx", data)
        })
        //        let token = toketParts.joined()
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print(#function, response)
        
        if response.notification.request.identifier == kLocalNotificationIdentifier {
            return
        }
        
        //        let content = response.notification.request.content
        let userInfo = response.notification.request.content.userInfo
        if let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type") as? String
        {
            print("KEY : ",key)
            
            
            print("USER INFo : ",userInfo)
            
            if key == "chat" {
                
                if let response = userInfo["gcm.notification.response_arr"] as? String {
                    let jsonData = response.data(using: .utf8)!
                    let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                    
                    if let dic = dictionary  as? [String: Any]{
                        print(dic)
                        
                        let state = UIApplication.shared.applicationState
                        
                        if let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController {
                            
                            if let vc : ChatViewController = (vc as? ChatViewController) {
                                
                                if let senderID = dic["SenderID"] as? String {
                                    if senderID == vc.receiverID {
                                        vc.webserviceForChatHistory(isLoading: false)
                                    } else {
                                        //                                    if let chatListVC = vc.navigationController?.hasViewController(ofKind: ChatListViewController.self) as? ChatListViewController {
                                        //                                        vc.navigationController?.popViewController(animated: false)
                                        //                                        chatListVC.ChatFromNotification(dict: dic)
                                        //                                    }
                                        vc.receiverID = senderID
                                        vc.webserviceForChatHistory(isLoading: false)
                                        
                                    }
                                }
                            } else {
                                if let chatListVC = vc.navigationController?.hasViewController(ofKind: ChatListViewController.self) as? ChatListViewController {
                                    
                                    for controller in vc.navigationController?.viewControllers ?? [] {
                                        if(controller.isKind(of: ChatListViewController.self)) {
                                            vc.navigationController?.popToViewController(controller as! ChatListViewController, animated: true)
                                            break
                                        }
                                    }
                                    chatListVC.ChatFromNotification(dict: dic)
                                } else {
                                    if state == .inactive {
                                        NotificationCenter.default.addObserver(self, selector: #selector(loadChatVC), name: NotificationSetHomeVC, object: nil)
                                        SingletonClass.SharedInstance.userInfo = dic
                                    }
                                    if !vc.isKind(of: SplashViewController.self) {
                                        
                                        let storyboard = UIStoryboard(name: "ChatStoryboard", bundle: nil)
                                        let controller = storyboard.instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
                                        controller.receiverID = dic["SenderID"] as? String
                                        vc.navigationController?.pushViewController(controller, animated: false)
                                    }
                                }
                            }
                        }
                        //                    }
                    } else {
                        completionHandler()
                    }
                }
            } else if key == "friend_request" {
                loadFriendsRequest()
            } else if key == "coins_transfer" {
                loadWallet()
            } else if key == "friend_request_accept" {
                acceptFriedRequestNotificationHandle()
            }else if key == "order_update" {
                if let response = userInfo["gcm.notification.response_arr"] as? String {
                    let jsonData = response.data(using: .utf8)!
                    let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                    if let dic = dictionary  as? [String: Any]
                    {
                        if let productDetailVC = UIApplication.topViewController() as? ProductDetailViewController
                        {
                            if let productID = dic["product_id"] as? String
                            {
                                productDetailVC.strOrderStatus = ((dic["order_status"] as? String ?? "").capitalizingFirstLetter())
                                //productDetailVC.webserviceForProductDetails(productId: productID)
                                productDetailVC.webserviceForOfferDetails(productId: productID)
                            }
                        }
                        else
                        {
                            
                            if let productID = dic["product_id"] as? String
                            {
                                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                
                                let controller = mainStoryboard.instantiateViewController(withIdentifier: ProductDetailViewController.className) as! ProductDetailViewController
                                controller.viewType = .History
                                controller.strOrderStatus = ((dic["order_status"] as? String ?? "").capitalizingFirstLetter())
                                controller.productID = productID
                                UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print(#function, notification.request.content.userInfo)
        
        if notification.request.identifier == kLocalNotificationIdentifier {
            completionHandler([.alert, .sound])
            return
        }
        
        //        let content = notification.request.content
        let userInfo = notification.request.content.userInfo
        if let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type") as? String {
            print("KEY : ",key)
            
            
            print("USER INFo : ",userInfo)
            
            
            if key == "chat" {
                
                if let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController {
                    if let vc : ChatViewController = (vc as? ChatViewController) {
                        if let response = userInfo["gcm.notification.response_arr"] as? String {
                            let jsonData = response.data(using: .utf8)!
                            let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                            if let dic = dictionary  as? [String: Any]
                            {
                                if let senderID = dic["SenderID"] as? String
                                {
                                    if(vc.receiverID != senderID)
                                    {
                                        completionHandler([.alert, .sound])
                                    }
                                    else
                                    {
                                        vc.webserviceForChatHistory(isLoading: false)
                                    }
                                }
                            }
                        }
                    } else if let vc : ChatListViewController = (vc as? ChatListViewController) {
                        completionHandler([.alert, .sound])
                        vc.webserviceForChatList()
                    } else if let vc : TabViewController = (vc as? TabViewController) {
                        completionHandler([.alert, .sound])
                        if vc.selectedIndex == TabBarOptions.Profile.rawValue {
                            vc.btnTabTapped(vc.btnTabs![vc.selectedIndex])
                        }
                    }else {
                        completionHandler([.alert, .sound])
                    }
                } else {
                    //                NotificationCenter.default.post(name: NotificationBadges, object: content)
                    completionHandler([.alert, .sound])
                }
            } else if key == "friend_request" {
//                loadFriendsRequest()
                completionHandler([.alert, .sound])
                
            } else if key == "coins_transfer" {
//                loadWallet()
                completionHandler([.alert, .sound])
                
            } else if key == "friend_request_accept" {
//                acceptFriedRequestNotificationHandle()
                completionHandler([.alert, .sound])
                
            } else if key == "friend_request_reject" {
                completionHandler([.alert, .sound])
            }
            else if key == "WebviewS" {
                if let topViewController = UIApplication.topViewController() as? Gateway3DSecureViewController
                {
                    topViewController.dismiss(animated: true) {
                        
                        //                    UtilityClass.showAlert(Message: "Purchase Successfull")
                        UtilityClass.showAlertWithCompletion(title: "", Message: "Purchase Successfull".localized, ButtonTitle: "OK".localized) {
                            UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                completionHandler([.alert, .sound])
            }
            else if key == "WebviewF" {
                if let topViewController = UIApplication.topViewController() as? Gateway3DSecureViewController
                {
                    topViewController.dismiss(animated: true) {
                        
                        //                    UtilityClass.showAlert(Message: "Purchase Successfull")
                        UtilityClass.showAlertWithCompletion(title: "", Message: "Purchase Unsuccessfull".localized, ButtonTitle: "OK".localized) {
                            //                                UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                completionHandler([.alert, .sound])
            }
          /*  else if key == "order_update" {
                if let response = userInfo["gcm.notification.response_arr"] as? String {
                    let jsonData = response.data(using: .utf8)!
                    let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                    if let dic = dictionary  as? [String: Any]
                        {
                        if let productID = dic["product_id"] as? String
                        {
                            if let topViewController = UIApplication.topViewController() as? ProductDetailViewController
                            {
                                if let orderID = dic["order_id"] as? String
                                {
                                    if(orderID == topViewController.orderDetail?.orderID)
                                    {
                                        for viewController in topViewController.parent?.children ?? []
                                        {
                                            if(viewController.isKind(of: PurchaseHistoryViewController.self))
                                            {
                                                (viewController as? PurchaseHistoryViewController)?.webserviceForPurchasehistory()
                                            }
                                        }
                                        topViewController.strOrderStatus = ((dic["order_status"] as? String ?? "").capitalizingFirstLetter())
                                        //topViewController.webserviceForProductDetails(productId: productID)
                                        topViewController.webserviceForOfferDetails(productId: productID)
                                    }
                                }
                                
                            }
                        }
                    }
                }


              
                completionHandler([.alert, .sound])

            }*/
            else if key == "Logout" {
                self.GoToLogout()
                if let aps = ((userInfo["aps"] as? [String:Any])?["alert"] as? [String:Any])?["title"] as? String
                {
                    UtilityClass.showAlert(Message: aps )
                    
                }
                completionHandler([.alert, .sound])
            }
            else if key.lowercased() == "block".lowercased() {
                if let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController {
                    if let vc : ChatViewController = (vc as? ChatViewController) {
                        if let response = userInfo["gcm.notification.response_arr"] as? String {
                            let jsonData = response.data(using: .utf8)!
                            let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                            if let dic = dictionary  as? [String: Any]
                            {
                                if let senderID = dic["block_by"] as? String
                                {
                                    if(vc.receiverID == senderID)
                                    {
                                        vc.bottomViewConstraintHeight.constant = 0
                                        vc.bottomView.isHidden = true
                                        vc.parent?.children.forEach({ (viewController) in
                                            if(viewController.isKind(of: FriendsViewController.self))
                                            {
                                                (viewController as? FriendsViewController)?.webserviceForFriendsList(isLoading: false)
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
                else if key.lowercased() == "challange_ended".lowercased() {
                    completionHandler([.alert, .sound])
                }
//                completionHandler([.alert, .sound])
            }
//            completionHandler([.alert, .sound])
        }
    }
    
    
    // ----------------------------------------------------
    //MARK:- === Firebase Methods ======
    // ----------------------------------------------------
    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print(remoteMessage)
//    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        
        SingletonClass.SharedInstance.DeviceToken = fcmToken ?? ""
        UserDefaults.standard.set(fcmToken, forKey: UserDefaultKeys.kDeviceToken)
    }
    
    
}
