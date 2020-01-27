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
 
    
    // ----------------------------------------------------
    //MARK:- --------- Lifecycle Methods ---------
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetUp()
        webserviceforAPPInit()
        playLogoAnimation()
    }
    
    // ----------------------------------------------------
    //MARK:- --------- Custom Methods ---------
    // ----------------------------------------------------
    
    
    func playLogoAnimation() {
        guard let path = Bundle.main.path(forResource: "Blue Conv", ofType:"mp4") else {
//        guard let path = Bundle.main.path(forResource: "White Conv", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        let playerItem = AVPlayerItem(url: URL(fileURLWithPath: path))
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        
        playerLayer.backgroundColor = UIColor.clear.cgColor
        viewContainer.backgroundColor = UIColor.clear
        
        viewContainer.layer.addSublayer(playerLayer)
        player.play()
        player.rate = 1.5
        Timer.scheduledTimer(withTimeInterval: 4.5, repeats: false) { (timer) in
//            if self.initStatus {
                self.moveToViewController()
//            }
        }
    }
    
    func moveToViewController() {
    
        if let loggedIn = UserDefaults.standard.value(forKey: UserDefaultKeys.kIsLogedIn) {
            
            if loggedIn as! Bool {
                AppDelegateShared.GoToHome()
                getUserData()
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
        
        strParam = NetworkEnvironment.baseURL + ApiKey.Init.rawValue + kAPPVesion + "/Ios"
      
        UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
            print(status)
            self.initStatus = status
            if status{
                 let initResponseModel = InitResponse(fromJson: json)
                SingletonClass.SharedInstance.productType = initResponseModel.category
                SingletonClass.SharedInstance.coinsDiscountRelation = initResponseModel.coinsDiscountRelation
            }else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
