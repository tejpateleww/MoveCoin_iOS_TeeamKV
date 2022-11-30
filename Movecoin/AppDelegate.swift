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
    var appDidEnterBackground = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()

        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        NotificationCenter.default.addObserver(self, selector:#selector(self.calendarDayDidChange(_:)), name:NSNotification.Name.NSCalendarDayChanged, object:nil)

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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("App is in Background mode")
        SocketIOManager.shared.establishConnection()
        SocketIOManager.shared.socket.on(clientEvent: .connect) { (data, ack) in
            print ("socket connected")
        }
        print(SocketIOManager.shared.isSocketOn)
        
        
        appDidEnterBackground = true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        if (((AppDelegateShared.window?.rootViewController as? UINavigationController)?.topViewController as? ChatViewController) != nil) {
            let vc = (AppDelegateShared.window?.rootViewController as? UINavigationController)?.topViewController as! ChatViewController
            vc.webserviceForChatHistory(isLoading: false)
        }
        
        appDidEnterBackground = false
        // If LastUpdatedDate and Current Date is same then Main Today's steps should be 0 if it opens from background 
//        if let topViewController = UIApplication.topViewController()?.children.first as? HomeViewController {
            DispatchQueue.main.async {
                self.webserviceforAPPInit()

               
            }
//        }
    }
    
    
    func webserviceforAPPInit(isFromLogin:Bool = false,completion: (() -> Void)? = nil){
        
        var strParam = String()
        
        strParam = NetworkEnvironment.baseURL + ApiKey.Init.rawValue + kAPPVesion + "/Ios/\(SingletonClass.SharedInstance.userData?.iD ?? "")"
        
        UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
            print(status)
            if status{
                let initResponseModel = InitResponse(fromJson: json)
                
              let diffOfDays = self.getDayDifference(fromDate: initResponseModel.serverTime, toDate: SingletonClass.SharedInstance.serverTime ?? "")
                
                SingletonClass.SharedInstance.lastUpdatedStepsAt = initResponseModel.lastUpdateStepAt
                SingletonClass.SharedInstance.productType = initResponseModel.category
                SingletonClass.SharedInstance.coinsDiscountRelation = initResponseModel.coinsDiscountRelation
                SingletonClass.SharedInstance.serverTime = initResponseModel.serverTime
                SingletonClass.SharedInstance.initResponse = initResponseModel
                
                if(diffOfDays > 0)
                {
                    let theNotification: NSNotification =
                    NSNotification(name: NSNotification.Name(rawValue: ""), object: nil, userInfo: [:])
                    self.calendarDayDidChange(theNotification)
                }
                completion?()
                
            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func getDayDifference(fromDate : String, toDate : String) -> Int
    {
        let now = UtilityClass.getDate(dateString: fromDate, dateFormate: DateFomateKeys.api, currentDateFormat: DateFomateKeys.api)//getDateFromDateString(dateString: fromDate)
        
        let lastUpdatedStepsAt = toDate//UtilityClass.getDateFromDateString(dateString: toDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFomateKeys.api//"h:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = .current
        
        let statDate = dateFormatter.date(from: lastUpdatedStepsAt)
        return now.days(from: statDate ?? Date())
    }
    
    @objc private func calendarDayDidChange(_ notification : NSNotification) {
        webserviceforAPPInit {
            let navigationController = self.window?.rootViewController as! UINavigationController
            let homVC = (navigationController.children.first as? TabViewController)?.homeVC as? HomeViewController
            
            SingletonClass.SharedInstance.todaysStepCount = "1"
            //        homVC?.startCountingSteps()
            homVC?.lblTodaysStepCount.text = "0"
            homVC?.webserviceforUpdateStepsCount(stepsCount: SingletonClass.SharedInstance.todaysStepCount ?? "1", dateStr: homVC?.queryDate ?? "---", isFromAppDelegate: true, fromFunction: #function)
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
//            else if key == "WebviewS" {
//                if let topViewController = UIApplication.topViewController() as? Gateway3DSecureViewController
//                {
//                    topViewController.dismiss(animated: true) {
//
//                        //                    UtilityClass.showAlert(Message: "Purchase Successfull")
//                        UtilityClass.showAlertWithCompletion(title: "", Message: "Purchase Successfull".localized, ButtonTitle: "OK".localized) {
//                            UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
//                        }
//                    }
//                }
//                completionHandler([.alert, .sound])
//            }
//            else if key == "WebviewF" {
//                if let topViewController = UIApplication.topViewController() as? Gateway3DSecureViewController
//                {
//                    topViewController.dismiss(animated: true) {
//
//                        //                    UtilityClass.showAlert(Message: "Purchase Successfull")
//                        UtilityClass.showAlertWithCompletion(title: "", Message: "Purchase Unsuccessfull".localized, ButtonTitle: "OK".localized) {
//                            //                                UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
//                        }
//                    }
//                }
//                completionHandler([.alert, .sound])
//            }
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
