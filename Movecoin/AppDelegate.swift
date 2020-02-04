//
//  AppDelegate.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import Firebase
import SocketIO
import CoreLocation
import CoreMotion
import FBSDKCoreKit
import HealthKit
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: "MOCMQEYul9oCmCmYDXk8Q7nVN", consumerSecret: "Nv7qw5isiL2TrRQgQafRkJieHSbJyPnNTttaHVPKu4zEQBeXzX")
        
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
        locationPermission()
        
        configureNotification()
        Fabric.with([Crashlytics.self])
        
        return true
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
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = ApplicationDelegate.shared.application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        // Add any custom logic here.
        
        let access = TWTRTwitter.sharedInstance().application(application, open: url, options: options)
       
        return true
    }
    
}

// ----------------------------------------------------
//MARK:- === Custom methods ======
// ----------------------------------------------------

extension AppDelegate {
    
    func setupApplication(){
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localized

        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = loginStoryboard.instantiateViewController(withIdentifier: SplashViewController.className) as? SplashViewController
        let nav = UINavigationController(rootViewController: controller!)
        self.window?.rootViewController = nav
    }
    
    func setUpNavigationBar(){
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barStyle = UIBarStyle.blackOpaque
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
        //        let healthStore = HKHealthStore()
        //
        //        guard let type = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else { return  }
        //        let authorizationStatus = healthStore.authorizationStatus(for: type)
        //
        //
        //        if (HKHealthStore().authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!) != .sharingAuthorized) {
        //            AppDelegateShared.GoToPermission(type: StepsPermission(rawValue: "HeakthKit")!)
        //        } else {
        //            switch CMPedometer.authorizationStatus() {
        //            case .authorized, .notDetermined :
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyborad.instantiateViewController(withIdentifier: TabViewController.className) as! TabViewController
        let NavHomeVC = UINavigationController(rootViewController: destination)
        self.window?.rootViewController = NavHomeVC
        //
        //            case .denied, .restricted :
        //                AppDelegateShared.GoToPermission(type: StepsPermission(rawValue: "MotionAndFitness")!)
        //
        //            @unknown default:
        //                fatalError()
        //            }
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
        
//                let healthStore = HKHealthStore()
//                guard let type = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else { return  }
//                let authorizationStatus = healthStore.authorizationStatus(for: type)
//
//
//                if (HKHealthStore().authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!) != .sharingAuthorized) {
//                    AppDelegateShared.GoToPermission(type: StepsPermission(rawValue: "HeakthKit")!)
//                } else {
//                }
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
        SocketIOManager.shared.closeConnection()
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
    
    func loadWallet(){
        if let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController {
            if let vc : TabViewController = (vc as? TabViewController) {
                vc.btnTabTapped(vc.btnTabs[TabBarOptions.Wallet.rawValue])
            }
        }
    }
    
    @objc func loadChatVC(){
        let storyboard = UIStoryboard(name: "ChatStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
        let userinfo = SingletonClass.SharedInstance.userInfo
        controller.receiverID = userinfo?["SenderID"] as? String
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
        
        // Push Notification
        UIApplication.shared.registerForRemoteNotifications()
        
        //Local Notification for everyday at 9 am
        let content = UNMutableNotificationContent()
        content.title = kAppName
        content.body = "Don't forget to walk everyday and earn \(kAppName)"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 00
        //        let triggerInputForEverydayRepeat = Calendar.current.dateComponents([.day], from: Date())
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: kLocalNotificationIdentifier, content: content, trigger: trigger)
        let unc = UNUserNotificationCenter.current()
        unc.add(request, withCompletionHandler: { (error) in
            print(error?.localizedDescription ?? "")
        })
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
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")!
        
        print("USER INFo : ",userInfo)
        print("KEY : ",key)
        
        
        if userInfo["gcm.notification.type"] as! String == "chat" {
            
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
        } else if userInfo["gcm.notification.type"] as! String == "friend_request" {
            loadFriendsRequest()
        } else if userInfo["gcm.notification.type"] as! String == "coins_transfer" {
            loadWallet()
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
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")!
        
        print("USER INFo : ",userInfo)
        print("KEY : ",key)
        
        if userInfo["gcm.notification.type"] as! String == "chat" {
            
            if let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController {
                if let vc : ChatViewController = (vc as? ChatViewController) {
                    vc.webserviceForChatHistory(isLoading: false)
             /*       if let response = userInfo["gcm.notification.response_arr"] as? String {
                        let jsonData = response.data(using: .utf8)!
                        let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                        
                        if let dic = dictionary  as? [String: Any]{
                            print(dic)
                            
                            if let senderID = dic["SenderID"] as? String {
                                if senderID == vc.receiverID {
                                    
                                    let chat = MessageData(ReceiverID: dic["ReceiverID"] as? String ?? "", Message: dic["Message"] as? String ?? "", SenderNickname: dic["sender_nickname"] as? String ?? "", SenderName: dic["sender_name"] as? String ?? "", SenderID: dic["SenderID"] as? String ?? "", Date: dic["Date"] as? String ?? "", ChatId: dic["chat_id"] as? String ?? "")
                                    print(chat)
                                    vc.arrData.append(chat)
                                    let indexPath = IndexPath.init(row: vc.arrData.count-1, section: 0)
                                    vc.tblVw.insertRows(at: [indexPath], with: .bottom)
                                    let path = IndexPath.init(row: vc.arrData.count-1, section: 0)
                                    vc.tblVw.scrollToRow(at: path, at: .bottom, animated: true)
                                } else{
                                    completionHandler([.alert, .sound])
                                }
                            }
                        }
                    } */
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
        } else if userInfo["gcm.notification.type"] as! String == "friend_request" {
            loadFriendsRequest()
            completionHandler([.alert, .sound])
        }else if userInfo["gcm.notification.type"] as! String == "coins_transfer" {
            loadWallet()
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

// ----------------------------------------------------
//MARK:- === Localization  ======
// ----------------------------------------------------

extension String {
    var localized: String {

        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

//i18n_language = sw

// ----------------------------------------------------------
// ----------------------------------------------------------

let LCLBaseBundle = "Base"
let secondLanguage = "ar-AE" // "sw"
var count = 0
var shouldLocalize = true
extension UILabel {

    override open func layoutSubviews() {
        super.layoutSubviews()
        if(shouldLocalize == true)
        {
            if self.text != nil {
                //            count = count + 1
                self.text =  self.text?.localized
                //            print("The count is \(count)")
            }
        }
    }
}

/// Internal current language key
let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"

/// Default language. English. If English is unavailable defaults to base localization.
let LCLDefaultLanguage = "en"

/// Base bundle as fallback.
//let LCLBaseBundle = "Base"

/// Name for language change notification
public let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"

// MARK: Localization Syntax
/**
 Swift 1.x friendly localization syntax, replaces NSLocalizedString
 - Parameter string: Key to be localized.
 - Returns: The localized string.
 */
public func Localized(_ string: String) -> String {
    return string.localized1()
}

/**
 Swift 1.x friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
 - Parameter string: Key to be localized.
 - Returns: The formatted localized string with arguments.
 */
public func Localized(_ string: String, arguments: CVarArg...) -> String {
    return String(format: string.localized1(), arguments: arguments)
}

/**
 Swift 1.x friendly plural localization syntax with a format argument
 
 - parameter string:   String to be formatted
 - parameter argument: Argument to determine pluralisation
 
 - returns: Pluralized localized string.
 */
public func LocalizedPlural(_ string: String, argument: CVarArg) -> String {
    return string.localizedPlural(argument)
}


public extension String {
    /**
     Swift 2 friendly localization syntax, replaces NSLocalizedString
     - Returns: The localized string.
     */
    func localized1() -> String {
        if let path = Bundle.main.path(forResource: Localize.currentLanguage(), ofType: "lproj"), let bundle = Bundle(path: path) {
//            print("Path: \(path)")
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        else if let path = Bundle.main.path(forResource: LCLBaseBundle, ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        return self
    }
    
    
    /**
     Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
     - Returns: The formatted localized string with arguments.
     */
    func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: localized1(), arguments: arguments)
    }
    
    /**
     Swift 2 friendly plural localization syntax with a format argument
     
     - parameter argument: Argument to determine pluralisation
     
     - returns: Pluralized localized string.
     */
    func localizedPlural(_ argument: CVarArg) -> String {
        return NSString.localizedStringWithFormat(localized1() as NSString, argument) as String
    }
}



// MARK: Language Setting Functions

open class Localize: NSObject {
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    open class func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.index(of: "Base"), excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    /**
     Current language
     - Returns: The current language. String.
     */
    open class func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: "i18n_language") as? String {
//            print("currentLanguage: \(currentLanguage)")
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    /**
     Change the current language
     - Parameter language: Desired language.
     */
    open class func setCurrentLanguage(_ language: String) {
        
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        }
    }
    
    /**
     Default language
     - Returns: The app's default language. String.
     */
    open class func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return LCLDefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages()
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = LCLDefaultLanguage
        }
        return defaultLanguage
    }
    
    /**
     Resets the current language to the default
     */
    open class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    open class func displayNameForLanguage(_ language: String) -> String {
        let locale : Locale = Locale(identifier: currentLanguage())
        if let displayName = (locale as NSLocale).displayName(forKey: NSLocale.Key.languageCode, value: language) {
            return displayName
        }
        return String()
    }
}


func localizeString(stringToLocalize:String) -> String
{
    // Get the corresponding bundle path.
    let selectedLanguage = Localize.currentLanguage()
    let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj")
    
    // Get the corresponding localized string.
    let languageBundle = Bundle(path: path!)
    return languageBundle!.localizedString(forKey: stringToLocalize, value: "", table: nil)
}

func localizeUI(parentView:UIView)
{
    for view:UIView in parentView.subviews
    {
        if let potentialButton = view as? UIButton
        {
            if let titleString = potentialButton.titleLabel?.text {
                potentialButton.setTitle(localizeString(stringToLocalize: titleString), for: .normal)
            }
        }
            
        else if let potentialLabel = view as? UILabel
        {
            if potentialLabel.text != nil {
                potentialLabel.text = localizeString(stringToLocalize: potentialLabel.text!)
            }
        }
        
        localizeUI(parentView: view)
    }
}
