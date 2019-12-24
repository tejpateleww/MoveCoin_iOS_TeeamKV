//
//  AppDelegate.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation
import CoreMotion
import Fabric
import Crashlytics
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let status = CMPedometer.authorizationStatus()
        
        print("Permission : ",status.rawValue)
        
        setupApplication()
        setUpNavigationBar()
        locationPermission()
        
        configureNotification()
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        if (((AppDelegateShared.window?.rootViewController as? UINavigationController)?.topViewController as? ChatViewController) != nil) {
            let vc = (AppDelegateShared.window?.rootViewController as? UINavigationController)?.topViewController as! ChatViewController
            vc.webserviceForChatHistory(isLoading: false)
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

// ----------------------------------------------------
//MARK:- === Custom methods ======
// ----------------------------------------------------

extension AppDelegate {
    
    func setupApplication(){
        IQKeyboardManager.shared.enable = true
        
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = loginStoryboard.instantiateViewController(withIdentifier: SplashViewController.className) as? SplashViewController
        let nav = UINavigationController(rootViewController: controller!)
        self.window?.rootViewController = nav
    }
    
    func setUpNavigationBar(){
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barStyle = UIBarStyle.blackOpaque
        navigationBarAppearace.tintColor           = UIColor.white
        
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
            //            let alert = UIAlertController(title: AppName.kAPPName, message: "Please enable location from settings", preferredStyle: .alert)
            //            let enable = UIAlertAction(title: "Enable", style: .default) { (temp) in
            //
            //                if let url = URL.init(string: UIApplication.openSettingsURLString) {
            //                    UIApplication.shared.open(URL(string: "App-Prefs:root=Privacy&path=LOCATION") ?? url, options: [:], completionHandler: nil)
            //                }
            //            }
            //            alert.addAction(enable)
            //            self.window?.rootViewController?.present(alert, animated: true, completion: nil )
            //            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func GoToPermission() {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyborad.instantiateViewController(withIdentifier: PermissionAlertViewController.className) as! PermissionAlertViewController
        let NavHomeVC = UINavigationController(rootViewController: destination)
        self.window?.rootViewController = NavHomeVC
    }
    
    func GoToHome() {
        //        switch CMPedometer.authorizationStatus() {
        //        case .authorized, .notDetermined :
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyborad.instantiateViewController(withIdentifier: TabViewController.className) as! TabViewController
        let NavHomeVC = UINavigationController(rootViewController: destination)
        self.window?.rootViewController = NavHomeVC
        
        //        case .denied, .restricted :
        //            AppDelegateShared.GoToPermission()
        //
        //        @unknown default:
        //            fatalError()
        //        }
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
        
        //        for (key, _) in UserDefaults.standard.dictionaryRepresentation() {
        //
        //            if key == "Token" || key  == UserDefaultKeys.IsLogin {
        //                //                print("\(key) = \(value) \n")
        //            } else {
        //                UserDefaults.standard.removeObject(forKey: UserDefaultKeys.IsLogin)
        //            }
        //        }
        //        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.kIsLogedIn)
        self.GoToLogin()
    }
    
    func GetTopViewController() -> UIViewController {
        return self.window!.rootViewController!
    }
    
    func loadFriendsRequest(){
        if let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController {
            if let vc : InviteViewController = (vc as? InviteViewController) {
                vc.isFromNotification = true
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
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: InviteViewController.className) as! InviteViewController
                    controller.isFromNotification = true
                    vc.navigationController?.pushViewController(controller, animated: false)
                }
            }
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- Push Notification Methods ---------
// ----------------------------------------------------

extension AppDelegate {
    
    func configureNotification() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                SingletonClass.SharedInstance.DeviceToken = result.token
                UserDefaults.standard.set(SingletonClass.SharedInstance.DeviceToken, forKey: UserDefaultKeys.kDeviceToken)
            }
        }
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        
        UIApplication.shared.registerForRemoteNotifications()
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
    /*
     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
     
     print(#function, userInfo)
     
     Messaging.messaging().appDidReceiveMessage(userInfo)
     //        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")!
     
     if(application.applicationState == .background) {
     DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
     let navController = self.window?.rootViewController as? UINavigationController
     let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
     navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
     })
     }
     }
     else{
     let data = ((userInfo["aps"]! as! [String : AnyObject])["alert"]!) as! [String : AnyObject]
     
     print("data : ",data)
     
     //            let alert = UIAlertController(title: AppNAME.localized, message: data["title"] as? String, preferredStyle: UIAlertController.Style.alert)
     
     //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
     }
     Messaging.messaging().appDidReceiveMessage(userInfo)
     }
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print(#function, response)
        //            singletoneClass.shared.notificationCounter += 1
        
        let content = response.notification.request.content
        let userInfo = response.notification.request.content.userInfo
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")!
        
        print("USER INFo : ",userInfo)
        print("KEY : ",key)
        
        if userInfo["gcm.notification.type"] as! String == "chat" {
            
            if let response = userInfo["gcm.notification.response_arr"] as? String {
                let jsonData = response.data(using: .utf8)!
                let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                
                if let dic = dictionary  as? [String: Any]{
                    print(dic)
                    
                    if let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController {
                        if let vc : ChatViewController = (vc as? ChatViewController) {
                            
                            if let senderID = dic["SenderID"] as? String {
                                if senderID == vc.userData["id"] {
                                    let chat = MessageData(ReceiverID: dic["ReceiverID"] as? String ?? "", Message: dic["Message"] as? String ?? "", SenderNickname: dic["sender_nickname"] as? String ?? "", SenderName: dic["sender_name"] as? String ?? "", SenderID: dic["SenderID"] as? String ?? "", Date: dic["Date"] as? String ?? "", ChatId: dic["chat_id"] as? String ?? "")
                                    print(chat)
                                    vc.arrData.append(chat)
                                    let indexPath = IndexPath.init(row: vc.arrData.count-1, section: 0)
                                    vc.tblVw.insertRows(at: [indexPath], with: .bottom)
                                    let path = IndexPath.init(row: vc.arrData.count-1, section: 0)
                                    vc.tblVw.scrollToRow(at: path, at: .bottom, animated: true)
                                } else {
                                    
                                    if let chatListVC = vc.navigationController?.hasViewController(ofKind: ChatListViewController.self) as? ChatListViewController {
                                        vc.navigationController?.popViewController(animated: false)
                                        chatListVC.ChatFromNotification(dict: dic)
                                    }
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
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let controller = storyboard.instantiateViewController(withIdentifier: ChatListViewController.className) as! ChatListViewController
                                vc.navigationController?.pushViewController(controller, animated: false)
                                controller.ChatFromNotification(dict: dic)
                            }
                        }
                    }
                } else {
                    NotificationCenter.default.post(name: NotificationBadges, object: content)
                    completionHandler()
                }
            }
        } else if userInfo["gcm.notification.type"] as! String == "friend_request" {
            loadFriendsRequest()
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print(#function, notification.request.content.userInfo)
        
        let content = notification.request.content
        let userInfo = notification.request.content.userInfo
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")!
        
        print("USER INFo : ",userInfo)
        print("KEY : ",key)
        
        if userInfo["gcm.notification.type"] as! String == "chat" {
            
            if let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController {
                if let vc : ChatViewController = (vc as? ChatViewController) {
                    
                    if let response = userInfo["gcm.notification.response_arr"] as? String {
                        let jsonData = response.data(using: .utf8)!
                        let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                        
                        if let dic = dictionary  as? [String: Any]{
                            print(dic)
                            
                            if let senderID = dic["SenderID"] as? String {
                                if senderID == vc.userData["id"] {
                                    let chat = MessageData(ReceiverID: dic["ReceiverID"] as? String ?? "", Message: dic["Message"] as? String ?? "", SenderNickname: dic["sender_nickname"] as? String ?? "", SenderName: dic["sender_name"] as? String ?? "", SenderID: dic["SenderID"] as? String ?? "", Date: dic["Date"] as? String ?? "", ChatId: dic["chat_id"] as? String ?? "")
                                    print(chat)
                                    vc.arrData.append(chat)
                                    let indexPath = IndexPath.init(row: vc.arrData.count-1, section: 0)
                                    vc.tblVw.insertRows(at: [indexPath], with: .bottom)
                                    let path = IndexPath.init(row: vc.arrData.count-1, section: 0)
                                    vc.tblVw.scrollToRow(at: path, at: .bottom, animated: true)
                                } else{
//                                    NotificationCenter.default.post(name: NotificationBadges, object: content)
                                    completionHandler([.alert, .sound])
                                }
                            }
                        }
                    }
                } else {
//                    NotificationCenter.default.post(name: NotificationBadges, object: content)
                    completionHandler([.alert, .sound])
                }
            } else {
//                NotificationCenter.default.post(name: NotificationBadges, object: content)
                completionHandler([.alert, .sound])
            }
        } else if userInfo["gcm.notification.type"] as! String == "friend_request" {
            loadFriendsRequest()
            completionHandler([.alert, .sound])
        }
    }
    
    
    // ----------------------------------------------------
    //MARK:- === Firebase Methods ======
    // ----------------------------------------------------
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        SingletonClass.SharedInstance.DeviceToken = fcmToken
        UserDefaults.standard.set(fcmToken, forKey: UserDefaultKeys.kDeviceToken)
        //    let dataDict:[String: String] = ["token": fcmToken]
        //    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}
