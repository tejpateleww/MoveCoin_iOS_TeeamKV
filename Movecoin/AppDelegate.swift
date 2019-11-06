//
//  AppDelegate.swift
//  Movecoin
//
//  Created by eww090 on 10/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //GoToHome()
        setupApplication()
        setUpNavigationBar()
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
        navigationBarAppearace.isHidden = true
        navigationBarAppearace.barStyle = UIBarStyle.blackTranslucent
        
        navigationBarAppearace.tintColor           = UIColor.white
        navigationBarAppearace.isTranslucent         = true
        navigationBarAppearace.shadowImage         = UIImage()
        navigationBarAppearace.backgroundColor     = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
        
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)
        
        guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
            return
        }
        statusBarView.backgroundColor = .clear
    }
    
    func GoToHome() {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyborad.instantiateViewController(withIdentifier: TabViewController.className) as! TabViewController
        let NavHomeVC = UINavigationController(rootViewController: destination)
        self.window?.rootViewController = NavHomeVC
    }
    
    func GoToLogin() {
        
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
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.IsLogin)
        self.GoToLogin()
    }
}

