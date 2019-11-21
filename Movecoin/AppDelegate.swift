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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let status = CMPedometer.authorizationStatus()
        print("Permission : ",status.rawValue)
        
        setupApplication()
        setUpNavigationBar()
        locationPermission()
        
        Fabric.with([Crashlytics.self])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
      
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
      
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
    }
    
    // ----------------------------------------------------
    //MARK:- === Push Notification Methods ======
    // ----------------------------------------------------
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(deviceTokenString)")
        
        _ = deviceToken.map({ (data)-> String in
            return String(format: "%0.2.2hhx", data)
        })
        //        let token = toketParts.joined()
//        Messaging.messaging().apnsToken = deviceToken as Data
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
//        nav.navigationBar.isHidden = true
        self.window?.rootViewController = nav
    }
    
    func setUpNavigationBar(){
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barStyle = UIBarStyle.blackOpaque
        navigationBarAppearace.tintColor           = UIColor.white

        // For "Back" text remove from navigationbar
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)
        
        // Transparent Statusbar
//        if let view = UIApplication.shared.statusBarUIView {
//            view.backgroundColor = .clear
//        }
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
    
    func GoToLogin() {
        
//        let storyborad = UIStoryboard(name: "Login", bundle: nil)
//        let Login = storyborad.instantiateViewController(withIdentifier: OnBoradViewController.className) as! OnBoradViewController
//        let NavHomeVC = UINavigationController(rootViewController: Login)
//        //        NavHomeVC.isNavigationBarHidden = true
//        self.window?.rootViewController = NavHomeVC
        
        let storyborad = UIStoryboard(name: "Login", bundle: nil)
        let Login = storyborad.instantiateViewController(withIdentifier: WelcomeViewController.className) as! WelcomeViewController
        let NavHomeVC = UINavigationController(rootViewController: Login)
//        NavHomeVC.isNavigationBarHidden = true
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
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.kIsLogedIn)
        self.GoToLogin()
    }
    
    func GetTopViewController() -> UIViewController {
        return self.window!.rootViewController!
    }
}

