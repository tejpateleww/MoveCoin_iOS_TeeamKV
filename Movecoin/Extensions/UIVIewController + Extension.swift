//
//  UIVIewController + Extention.swift
//  Movecoin
//
//  Created by eww090 on 11/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func navigationBarSetUp(title: String, backroundColor: UIColor){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = backroundColor
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController?.navigationBar.tintColor = .white
      
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                              NSAttributedString.Key.font: UIFont(name: "Nunito-Regular", size: 20)!]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.title = title
    }
    
    func statusBarSetUp(backColor: UIColor, textStyle: UIBarStyle){
       
        guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
            return
        }
        statusBarView.backgroundColor = backColor
        self.navigationController?.navigationBar.barStyle = textStyle
    }
    
}
