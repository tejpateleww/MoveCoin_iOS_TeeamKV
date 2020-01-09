//
//  UserPermissionClass.swift
//  Movecoins
//
//  Created by eww090 on 29/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import MapKit
import UserNotifications
import Contacts
import AddressBook
import CoreMotion
import HealthKit
import CoreLocation

enum Permission : Int, CaseIterable{
    case camera = 0
    case photoLibrary = 1
    case mediaLibrary = 2
    case notification = 3
    case locationPermission = 4
    case contacts = 5
    case motion = 6
    case healthKit = 7
}


open class UserPermission : NSObject {
    
    lazy var permissionType : Permission = Permission.locationPermission
    lazy var permissions : [Permission] = []
    
    public override init() {
        super.init()
    }
    
    func requestForPermission(type permission : Permission) {
        switch permission {
        case .camera:
                requestCameraPermission()
            
        case .photoLibrary:
            requestPhotoLibraryPermission()
            
        case .locationPermission:
            requestLocationPermission()
            
        case .notification:
            requestNotificationPermission()
            
        case .contacts:
            requestContactsPermission()
            
        case .motion:
            requestMotionPermission()
            
        case .healthKit:
            requestHealthKitPermission()
            
        default:
            return
        }
    }
    
    func requestCameraPermission(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {
            finished in
            DispatchQueue.main.async {
                print("Camera Permsssion : ",finished)
            }
        })
    }
    
    func requestPhotoLibraryPermission(){
        PHPhotoLibrary.requestAuthorization({
            finished in
            DispatchQueue.main.async {
                print("Photo Library Permsssion : ",finished)
            }
        })
    }
    
    func requestLocationPermission(){
        let locationManager = CLLocationManager()
//        let status = CLLocationManager.authorizationStatus()
        if (CLLocationManager.authorizationStatus() == .denied) || CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .notDetermined {
            // Ask for Authorisation from the User.
            locationManager.requestAlwaysAuthorization()
            
            // For use in foreground
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func requestNotificationPermission() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                DispatchQueue.main.async {
                    print("Notification Permsssion : ",granted, error?.localizedDescription ?? "error")
                }
            }
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func requestContactsPermission() {
        if #available(iOS 9.0, *) {
            let store = CNContactStore()
            store.requestAccess(for: .contacts, completionHandler: { (granted, error) in
                DispatchQueue.main.async {
                     print("Contacts Permsssion : ",granted, error?.localizedDescription ?? "error")
                }
            })
        } else {
            let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
            ABAddressBookRequestAccessWithCompletion(addressBookRef) {
                (granted: Bool, error: CFError?) in
                DispatchQueue.main.async() {
                    print("Contacts Permsssion : ",granted, error?.localizedDescription ?? "error")
                }
            }
        }
    }
    
    func requestMotionPermission() {
        let manager = CMMotionActivityManager()
               let today = Date()
               
               manager.queryActivityStarting(from: today, to: today, to: OperationQueue.main, withHandler: { (activities: [CMMotionActivity]?, error: Error?) -> () in
                    print("Motion Permsssion : ", error?.localizedDescription ?? "error")
                   manager.stopActivityUpdates()
               })
    }
    
    func requestHealthKitPermission() {
        let healthStore = HKHealthStore()
        if HKHealthStore.isHealthDataAvailable() {
            let steps = NSSet(object: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) ?? 0)
            healthStore.requestAuthorization(toShare: [], read: steps as? Set<HKObjectType>) { (success, error) -> Void in
                if success {
                    print("success")
                } else {
                    print("failure")
                }
                
                if let error = error { print(error) }
            }
        }
    }
}
