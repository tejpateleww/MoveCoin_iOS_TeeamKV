//
//  SplashViewController.swift
//  Movecoin
//
//  Created by eww090 on 17/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import AVKit
import CoreMotion
import AVFoundation
class SplashViewController: UIViewController {
    
    // ----------------------------------------------------
    //MARK:- --------- IBOutlets ---------
    // ----------------------------------------------------
    
    
    @IBOutlet weak var viewContainer: UIView!
    
    // ----------------------------------------------------
    //MARK:- --------- Variables ---------
    // ----------------------------------------------------
    
    var initStatus = false
    var isAvailable = false
    
    lazy var userPermission = UserPermission()

    // ----------------------------------------------------
    //MARK:- --------- Lifecycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.initialSetup()
        if let loggedIn = UserDefaults.standard.value(forKey: UserDefaultKeys.kIsLogedIn) {
            if loggedIn as! Bool {
                getUserData()
            }
        }
        navigationBarSetUp()
        webserviceforAPPInit()
        playLogoAnimation()
    }
    
    // ----------------------------------------------------
    //MARK:- --------- Custom Methods ---------
    // ----------------------------------------------------
    
    
    func playLogoAnimation() {
        guard let path = Bundle.main.path(forResource: "INTRO", ofType:"mp4") else {
            //        guard let path = Bundle.main.path(forResource: "White Conv", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        let playerItem = AVPlayerItem(url: URL(fileURLWithPath: path))
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.backgroundColor = UIColor.clear.cgColor
        viewContainer.backgroundColor = UIColor.clear
        
        viewContainer.layer.addSublayer(playerLayer)
        player.play()
        player.rate = 1.5
//        NotificationCenter.default.addObserver(self, selector: #selector(moveToViewController), name: .AVPlayerItemDidPlayToEndTime, object: nil)

//        Timer.scheduledTimer(withTimeInterval: 4.5, repeats: false) { (timer) in
            //            if self.initStatus {
//            self.moveToViewController()
            //            }
//        }
    }
    
    @objc func moveToViewController() {
        self.initialSetup()

        if let loggedIn = UserDefaults.standard.value(forKey: UserDefaultKeys.kIsLogedIn) {
            
            if loggedIn as! Bool {
                AppDelegateShared.GoToHome()
                //                getUserData()
            }else {
                AppDelegateShared.GoToLogin()
            }
        } else if UserDefaults.standard.value(forKey: UserDefaultKeys.kIsOnBoardLaunched) == nil {
            //                if (isOnBoardLaunched as! Bool) == false {
            AppDelegateShared.GoToOnBoard()
            //                }
        } else {
            AppDelegateShared.GoToLogin()
        }
    }
    
    func webserviceforAPPInit(){
        
        var strParam = String()
        
        strParam = NetworkEnvironment.baseURL + ApiKey.Init.rawValue + kAPPVesion + "/Ios/\(SingletonClass.SharedInstance.userData?.iD ?? "")"
        
        UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
            print(status)
            self.initStatus = status
            if status{
                let initResponseModel = InitResponse(fromJson: json)
                SingletonClass.SharedInstance.lastUpdatedStepsAt = initResponseModel.lastUpdateStepAt
                SingletonClass.SharedInstance.productType = initResponseModel.category
                SingletonClass.SharedInstance.coinsDiscountRelation = initResponseModel.coinsDiscountRelation
                SingletonClass.SharedInstance.serverTime = initResponseModel.serverTime
                SingletonClass.SharedInstance.initResponse = initResponseModel
                NotificationCenter.default.addObserver(self, selector: #selector(self.moveToViewController), name: .AVPlayerItemDidPlayToEndTime, object: nil)

                if let isUpdateAvailble = json["update"].bool {

                    if !isUpdateAvailble {
                        // Show an alert, Optional update is available :
                        if let msg = json["message"].string {
                            let alert = UIAlertController(title: kAppName.localized,
                                                          message: msg,
                                                          preferredStyle: UIAlertController.Style.alert)
                            
                            let okAction = UIAlertAction(title: "Update", style: .default, handler: { (action) in
                                if let url = URL(string: appURL) {
                                    UIApplication.shared.open(url)
                                    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                                }
                            })
                            let LaterAction = UIAlertAction(title: "Later", style: .default, handler: { (action) in
//                                self.setupNavigationToLogin()
                            })
                            
                            alert.addAction(okAction)
                            alert.addAction(LaterAction)
                            UIApplication.topViewController()?.present(alert, animated: true, completion: nil) // Display a two Action alert.  if yes then redirect to APP store :
                        }
                    }
                }
            }else{
                // Maintainance Flow :
                //  let update = json["update"].string
                
                if let update = json["update"].bool, update == false {
                    if let maintenance = json["maintenance"].bool, maintenance == true {
                        let msg = json["message"].stringValue
                        // stop user here :
                        let alert = UIAlertController(title: kAppName,
                                                      message: msg,
                                                      preferredStyle: UIAlertController.Style.alert)
                        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                        //  Utilities.displayAlertForMainantance(msg)
                    }else{
                        if let msg = json["message"].string {
                            let alert = UIAlertController(title: kAppName,
                                                          message: msg,
                                                          preferredStyle: UIAlertController.Style.alert)
                                                        
                            let okAction = UIAlertAction(title: "Update".localized, style: .default, handler: { (action) in
                                if let url = URL(string: appURL) {
                                    UIApplication.shared.open(url)
                                    UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                                }
                            })
                            let LaterAction = UIAlertAction(title: "Later".localized, style: .default, handler: {
                                (action) in
//                                self.setupNavigationToLogin()
                                AppDelegateShared.GoToHome()
                            })
                            alert.addAction(okAction)
                            alert.addAction(LaterAction)
                            UIApplication.topViewController()?.present(alert, animated: true, completion: nil) // Display a two Action alert.  if yes then redirect to APP store :
                        }
                    }
                } else if let update = json["update"].bool, update == true {
                    // Force update :
                    if let msg = json["message"].string {
                        let alert = UIAlertController(title: kAppName,
                                                      message: msg,
                                                      preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "Update".localized, style: .default, handler: { (action) in
                            if let url = URL(string: appURL) {
                                UIApplication.shared.open(url)
                                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                            }
                        })
                        alert.addAction(okAction)
                        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                    }
                }
                
                if let strMessage = json["message"].string {
                    UtilityClass.showAlertOfAPIResponse(param: strMessage)
                } else {
                    UtilityClass.showAlertOfAPIResponse(param: "Please check your internet".localized)
                }
            }
        }
    }
    
//    UtilityClass.showAlertOfAPIResponse(param: res)

    
    func initialSetup(){
//        let imageview = UIImageView(frame: self.view.frame)
//        imageview.image = UIImage(named: image)
//        imageview.contentMode = .scaleAspectFill
//        self.view.addSubview(imageview)
        
        // For Request Permission
//        let img = NSLocale.current.languageCode == "ar" ? "Intro 1 Arabic" : "intro-1"
//        if image == img {
        userPermission.permissions = [.camera, .motion, .healthKit, .locationPermission,.notification]
            for type in userPermission.permissions {
                userPermission.requestForPermission(type: type)
            }
        }
//    }
}
