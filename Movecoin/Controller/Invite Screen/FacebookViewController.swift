//
//  FacebookViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class FacebookViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblDescription: LocalizLabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        lblDescription.font = UIFont.regular(ofSize: 15)
        //        localizeUI(parentView: self.viewParent)
    }
    
    // ----------------------------------------------------
    //MARK:- --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func getFBUserData() {
        
        var parameters = [AnyHashable: Any]()
        parameters["fields"] = "first_name, last_name, email, id, user_friends"
        
        GraphRequest.init(graphPath: "me", parameters: parameters as! [String : Any]).start { (connection, result, error) in
            if error == nil {
                
                print("\(#function) \(result!)")
                let dictData = result as! [String : AnyObject]
             
                let strUserId = String(describing: dictData["id"]!)
                
                let request = GraphRequest(graphPath: "/\(strUserId)/friends", parameters: parameters as! [String : Any], httpMethod: HTTPMethod(rawValue: "GET"))
                request.start(completionHandler: { connection, result, error in
                    // Insert your code here
                    print("Friends Result: \(String(describing: result))")
                    print("Friends connection: \(String(describing: connection))")
                    print("Friends error: \(String(describing: error))")
                })
            }
            else{
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    // ----------------------------------------------------
    //MARK:- --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnConnectFacebookTapped(_ sender: Any) {
        if SingletonClass.SharedInstance.userData?.socialID.isBlank ?? true {
            if !WebService.shared.isConnected {
                UtilityClass.showAlert(Message: "Please check your internet")
                return
            }
            let login = LoginManager()
            login.logOut()
            login.logIn(permissions: ["public_profile","email","user_friends"], from: self) { (result, error) in
        
                if error != nil {
                    //                UIApplication.shared.statusBarStyle = .lightContent
                }
                else if (result?.isCancelled)! {
                    //                UIApplication.shared.statusBarStyle = .lightContent
                }else {
                    if (result?.grantedPermissions.contains("email"))! {
                        //                    UIApplication.shared.statusBarStyle = .lightContent
                        self.getFBUserData()
                    }else {
                        print("you don't have permission")
                    }
                }
            }
        }else {
            print("Already FB Connected")
            var parameters = [AnyHashable: Any]()
            parameters["fields"] = "first_name, last_name, email, id, user_friends"
            
            let id = SingletonClass.SharedInstance.userData?.socialID ?? ""
            let request = GraphRequest(graphPath: "/\(id)/friends", parameters: parameters as! [String : Any], httpMethod: HTTPMethod(rawValue: "GET"))
            request.start(completionHandler: { connection, result, error in
                // Insert your code here
                print("Friends Result: \(String(describing: result))")
                print("Friends connection: \(String(describing: connection))")
                print("Friends error: \(String(describing: error))")
            })
        }
    }
}
