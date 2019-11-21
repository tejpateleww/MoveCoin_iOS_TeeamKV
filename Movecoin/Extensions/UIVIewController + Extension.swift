//
//  UIVIewController + Extention.swift
//  Movecoin
//
//  Created by eww090 on 11/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

extension UIViewController {
    
   
    // ------------------------------------------------------------
    //MARK:- --------- NavigationBar & StatusBar Methods ---------
    // -------------------------------------------------------------
    
    
    func navigationBarSetUp(isHidden:Bool, title: String = "", backroundColor: UIColor = .clear, hidesBackButton: Bool = false) {
        // Hidden
        self.navigationController?.navigationBar.isHidden = isHidden
        // Back Hide
        self.navigationItem.hidesBackButton = hidesBackButton
        
        if !isHidden {
            // Title
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                  NSAttributedString.Key.font: UIFont.bold(ofSize: 25)]
            self.navigationController?.navigationBar.titleTextAttributes = textAttributes
            self.navigationController?.navigationBar.topItem?.title = title
//            self.navigationController?.navigationBar.tintColor = .white
            
            // Background
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.backgroundColor = backroundColor
            self.navigationController?.navigationBar.isTranslucent = true
        }
        statusBarSetUp(backColor: .clear)
    }
    
    func statusBarSetUp(backColor: UIColor, textStyle: UIBarStyle = .blackOpaque) {
       
        guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
            return
        }
        statusBarView.backgroundColor = backColor
//        self.navigationController?.navigationBar.barStyle = textStyle
    }
    
    func popViewControllerWithFlipAnimation(){
        UIView.transition(with: (self.navigationController?.view)!, duration: 1.0, options: .transitionFlipFromLeft, animations: {
            UIView.animate(withDuration: 0.2, animations: {
                self.navigationController?.popViewController(animated: false)
            })
        }, completion: nil)
    }
    
    func pushViewControllerWithFlipAnimation(viewController : UIViewController){
        UIView.transition(with: (self.navigationController?.view)!, duration: 1.0, options: .transitionFlipFromRight, animations: {
            UIView.animate(withDuration: 0.2, animations: {
                self.navigationController?.pushViewController(viewController, animated: false)
            })
        }, completion: nil)
    }
    
    // ----------------------------------------------------
    //MARK:- --------- TextField Methods ---------
    // ----------------------------------------------------
    
    func getWidth(text: String) -> CGFloat{
        let txtField = UITextField(frame: .zero)
        txtField.text = text
        txtField.sizeToFit()
        return txtField.frame.size.width
    }
    
    // ----------------------------------------------------
    //MARK:- --------- Location Methods ---------
    // ----------------------------------------------------
    
    func updateMylocation(){
        UpdateLocationClass.sharedLocationInstance.UpdateLocationStart()
        UpdateLocationClass.sharedLocationInstance.UpdatedLocation = { (LocationUpdated) in
            SingletonClass.SharedInstance.myCurrentLocation = LocationUpdated
            UpdateLocationClass.sharedLocationInstance.GeneralLocationManager.stopUpdatingLocation()
        }
    }
    
    // ----------------------------------------------------
    //MARK:- --------- Get UserData Methods ---------
    // ----------------------------------------------------
    
    func getUserData(){
        do{
            SingletonClass.SharedInstance.userData = try UserDefaults.standard.get(objectType: UserData.self, forKey: UserDefaultKeys.kUserProfile)!
        }catch{
            UtilityClass.showAlert(Message: error.localizedDescription)
            return
        }
        
        print("User Data :", SingletonClass.SharedInstance.userData?.toDictionary())
    }
    
//    func getTodaysStepCounts(label: UILabel) {
//        let pedoMeter = CMPedometer()
//        pedoMeter.queryPedometerData(from: Date().midnight, to: Date()) { (data, error) in
//            print("queryPedometerData : ", data ?? 0)
//            guard let activityData = data else {
//                return
//            }
//            DispatchQueue.main.async {
//                label.text = activityData.numberOfSteps.stringValue
//            }
//            SingletonClass.SharedInstance.todaysStepCount = activityData.numberOfSteps
//        }
//    }
    
    
}
