//
//  UIVIewController + Extention.swift
//  Movecoin
//
//  Created by eww090 on 11/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
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
    
    func getWidth(text: String) -> CGFloat{
        let txtField = UITextField(frame: .zero)
        txtField.text = text
        txtField.sizeToFit()
        return txtField.frame.size.width
    }
}
