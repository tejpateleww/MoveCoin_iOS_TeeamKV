//
//  SplashViewController.swift
//  Movecoin
//
//  Created by eww090 on 17/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import AVKit

class SplashViewController: UIViewController {
    
    // ----------------------------------------------------
    //MARK:- --------- IBOutlets ---------
    // ----------------------------------------------------
   
    @IBOutlet weak var viewContainer: UIView!
  
    
    // ----------------------------------------------------
    //MARK:- --------- Lifecycle Methods ---------
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
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
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { (timer) in
            self.moveToViewController()
        }
        
    }
    
    func moveToViewController(){
        
        if UserDefaults.standard.value(forKey: UserDefaultKeys.IsLogin) != nil {
            
            if UserDefaults.standard.value(forKey: UserDefaultKeys.IsLogin) as! Bool {
                AppDelegateShared.GoToHome()
            }else {
               AppDelegateShared.GoToLogin()
            }
        }else {
            AppDelegateShared.GoToLogin()
        }
    }
}
