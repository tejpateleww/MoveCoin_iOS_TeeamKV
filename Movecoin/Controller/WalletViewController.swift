//
//  WalletViewController.swift
//  Movecoin
//
//  Created by eww090 on 16/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        navigationBarSetUp(title: "Wallet", backroundColor: .clear)
        self.statusBarSetUp(backColor: .clear, textStyle: UIBarStyle.blackTranslucent)
    }

}
