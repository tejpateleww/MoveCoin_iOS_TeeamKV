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
        NotificationCenter.default.addObserver(self, selector: #selector(moveToViewController), name: .AVPlayerItemDidPlayToEndTime, object: nil)

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
            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    
    
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
