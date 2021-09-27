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
import CoreLocation

let locationManager = CLLocationManager()

extension UIViewController : CLLocationManagerDelegate {
    
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
   
    // ------------------------------------------------------------
    //MARK:- --------- NavigationBar & StatusBar Methods ---------
    // -------------------------------------------------------------
    
    
    func navigationBarSetUp(title: String = "", backroundColor: UIColor = .clear, foregroundColor : UIColor = .white, hidesBackButton: Bool = false) {

        // For Hide/Show Back Button
        self.navigationItem.hidesBackButton = hidesBackButton
        
        // Title
        let textAttributes = [NSAttributedString.Key.foregroundColor: foregroundColor,
                                                 NSAttributedString.Key.font: UIFont.regular(ofSize: 25)]
                           self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.topItem?.title = title.localized
        
        // Background
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = backroundColor
        
        self.navigationController?.navigationBar.semanticContentAttribute = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .forceRightToLeft : .forceLeftToRight

//        statusBarSetUp(backColor: .clear)
    }
    
    func statusBarSetUp(backColor: UIColor) {
       if let view = UIApplication.shared.statusBarUIView {
            view.backgroundColor = backColor
        }
    }
    
    func popViewControllerWithFlipAnimation() {
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
    //MARK:- --------- Get UserData Method ---------
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
    
    // ----------------------------------------------------
    //MARK:- --------- Gradient Method ---------
    // ----------------------------------------------------
    
    func setGradientColorOfView(view: UIView, startColor : UIColor, endColor: UIColor) {
        view.layoutIfNeeded()
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
//        let startColor = startColor.withAlphaComponent(0.15)
//        let endColor = endColor.withAlphaComponent(0)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        view.layoutIfNeeded()
    }
}
