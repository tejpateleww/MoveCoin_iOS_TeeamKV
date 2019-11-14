//
//  UpdateLocationClass.swift
//  HJM
//
//  Created by EWW082 on 25/09/19.
//  Copyright © 2019 EWW082. All rights reserved.
//

import Foundation
import CoreLocation



class UpdateLocationClass : NSObject, CLLocationManagerDelegate {
    
    static let sharedLocationInstance = UpdateLocationClass.init()
    
    var GeneralLocationManager = CLLocationManager()
    var CurrentLocation: CLLocation?
    
    var UpdatedLocation:((CLLocation) -> ())?
//    var UpdatedLocationLogin:((CLLocation) -> ())?
//    var UpdatedLocationHome:((CLLocation) -> ())?
//
    override init() {
        super.init()
        self.GeneralLocationManager.delegate = self
        self.GeneralLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        if CLLocationManager.locationServicesEnabled() == false {
//            self.GeneralLocationManager.requestLocation()
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         self.CurrentLocation  = locations.first!
        if let UpdateLocation = self.UpdatedLocation {
            UpdateLocation(locations.first!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // print (error)
        if (error as? CLError)?.code == .denied {
            GeneralLocationManager.stopUpdatingLocation()
            GeneralLocationManager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    func checkLocationPermission() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
               return false
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                return true
            default:
                print("Location services Default")
            }
        } else {
            print("Location services are not enabled")
            return false
        }
        return false
    }
  
    
    func UpdateLocationStart(){
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                if UserDefaults.standard.bool(forKey: UserDefaultKeys.kIsFirstTimeLocationUpdate) {
                    UtilityClass.alertForLocation(currentVC: AppDelegateShared.GetTopViewController())
                }
            case .authorizedAlways, .authorizedWhenInUse:
                self.GeneralLocationManager.startUpdatingLocation()
                
            @unknown default:
                break
            }
        } else {
            if UserDefaults.standard.bool(forKey: UserDefaultKeys.kIsFirstTimeLocationUpdate) {
                UtilityClass.alertForLocation(currentVC:AppDelegateShared.GetTopViewController())
                print("Location services are not enabled")
            }
        }
    }
    
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted,.denied,.notDetermined:
            self.GeneralLocationManager.stopUpdatingLocation()
            if UserDefaults.standard.bool(forKey: UserDefaultKeys.kIsFirstTimeLocationUpdate) {
                UtilityClass.alertForLocation(currentVC: AppDelegateShared.GetTopViewController())
            }
        case .authorizedAlways, .authorizedWhenInUse:
             self.GeneralLocationManager.startUpdatingLocation()
             print("Location status is OK.")
        @unknown default:
            print("")
        }
    }
    
}


