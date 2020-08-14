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
    @IBOutlet weak var tblFriends: UITableView!
    @IBOutlet var btnFacebook: ThemeButton!
//    @IBOutlet weak var lblDescription: LocalizLabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    lazy var fbFriendsArray : [User] = []
    lazy var getFBfriendsArray : [FacebookFriend] = []
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
//        lblDescription.font = UIFont.regular(ofSize: 15)
        //        localizeUI(parentView: self.viewParent)
    }
    
    // ----------------------------------------------------
    //MARK:- --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        tblFriends.delegate = self
        tblFriends.dataSource = self
        tblFriends.tableFooterView = UIView.init(frame: CGRect.zero)
        
        if SingletonClass.SharedInstance.userData?.socialID.isBlank ?? true {
            btnFacebook.isHidden = false
        } else {
            btnFacebook.isHidden = true
            getFacebookFriendList()
        }
    }
    
    func getFBUserData() {
        
        var parameters = [AnyHashable: Any]()
        parameters["fields"] = "first_name, last_name, email, id, user_friends"
        
        GraphRequest.init(graphPath: "me", parameters: parameters as! [String : Any]).start { (connection, result, error) in
            if error == nil {
                
                print("\(#function) \(result!)")
                let dictData = result as! [String : AnyObject]
                
                let strUserId = String(describing: dictData["id"]!)
                
                let request = GraphRequest(graphPath: "/\(strUserId)/friends", parameters: parameters as! [String : Any], httpMethod: .get)
                request.start(completionHandler: { connection, result, error in
                    // Insert your code here
                    print("Friends Result: \(String(describing: result))")
                    print("Friends connection: \(String(describing: connection))")
                    print("Friends error: \(String(describing: error))")
                    
                    guard let resultData = result else { return }
                    let resultdict = resultData as! [String : Any]
                    print("Result Dict: \(resultdict)")

                    let friends = resultdict["data"] as! Array<Any>
                    print("Found \(friends.count) friends")
                    print(friends)
                })
            }
            else{
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func getFacebookFriendList() {
        
//        UtilityClass.showHUD()
        
        var parameters = [AnyHashable: Any]()
        parameters["fields"] = "first_name, last_name, email, id"
        
        let id = SingletonClass.SharedInstance.userData?.socialID ?? ""
        let request = GraphRequest(graphPath: "/\(id)/friends", parameters: parameters as! [String : Any], httpMethod: .get)
        request.start(completionHandler: { connection, result, error in
            // Insert your code here
            print("Friends Result: \(String(describing: result))")
            print("Friends connection: \(String(describing: connection))")
            print("Friends error: \(String(describing: error))")
            
            if error != nil {
                UtilityClass.hideHUD()
                return
            }
            
            guard let resultData = result else { return }
            let resultdict = resultData as! [String : Any]
            print("Result Dict: \(resultdict)")

            let friendsArray = resultdict["data"] as! NSArray
            print("Found \(friendsArray.count) friends")
            print(friendsArray)
            
            
            
            for friend in friendsArray {
                let value = FacebookFriend(fromDictionary: friend as! [String : Any])
                self.getFBfriendsArray.append(value)
            }
            
            self.webserviceForInviteFriends(dic: self.getFBfriendsArray)
            
//            DispatchQueue.main.async {
//                self.tblFriends.reloadData()
//            }
        })
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
            self.getFacebookFriendList()
        }
    }
}


// ----------------------------------------------------
//MARK:- --------- TableView Methods ---------
// ----------------------------------------------------

extension FacebookViewController : UITableViewDelegate, UITableViewDataSource, InviteFriendCellDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //            return 65
        return 55
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fbFriendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FindFriendTableViewCell.className) as! FindFriendTableViewCell
        cell.selectionStyle = .none
        cell.cellDelegate = self
        
        cell.type = FriendsStatus.init(rawValue: "Recommended")
        DispatchQueue.main.async {
            switch cell.type {
                
            case .RecommendedFriend:
        
                cell.fbFriend = self.fbFriendsArray[indexPath.row]
                
//                if self.notFriendsArray.contains(cell.fbFriend?.iD ?? "") {
//                    cell.btnInvite.isHidden = false
//                } else {
//                    cell.btnInvite.isHidden = true
//                }
                
            default:
                break
            }
        }
        return cell
    }
    
    func didPressButton(_ cell: FindFriendTableViewCell) {
        switch cell.type {
      
        case .RecommendedFriend:
            if let recevierID = cell.fbFriend?.id {
                webserviceForAddFriends(id: recevierID)
            }
            
        default:
            break
        }
    }
}


// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension FacebookViewController {
    
    func webserviceForInviteFriends(dic : [FacebookFriend]){
        
        // JSON String for Sending facebook friend list
        var JSONstring = String()
        if let contactsDic = dic.asDictionaryArray {
            if let JSONData = try?  JSONSerialization.data(withJSONObject: contactsDic, options: []), let JSONText = String(data: JSONData, encoding: String.Encoding.utf8) {
                        JSONstring = JSONText
            }
        }
        let requestModel = SocialUserModel()
        requestModel.user_id = SingletonClass.SharedInstance.userData?.iD ?? ""
        requestModel.users = JSONstring

        FriendsWebserviceSubclass.socialUsers(socialUserModel: requestModel){ (json, status, res) in
            
//            UtilityClass.hideHUD()
            
            if status {
                
                let responseModel = SocialUserResponseModel(fromJson: json)
//                self.notFriendsArray = responseModel.notFriend
                self.fbFriendsArray = responseModel.users
                self.tblFriends.reloadData()
                
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    
    func webserviceForAddFriends(id : String){
        
        let requestModel = FriendRequestModel()
        requestModel.SenderID = SingletonClass.SharedInstance.userData?.iD ?? ""
        requestModel.social_id = id

        FriendsWebserviceSubclass.friendRequest(friendRequestModel: requestModel){ (json, status, res) in
            
            if status {
                
//                let filteredFriend = self.fbFriendsArray.filter{$0.id == id}
//                if let friend = filteredFriend.first {
//                    guard let index = self.fbFriendsArray.firstIndex(of: friend) else { return }
//                    self.fbFriendsArray.remove(at: index)
//                    DispatchQueue.main.async {
//                        self.tblFriends.reloadData()
//                    }
//                }
                
                self.webserviceForInviteFriends(dic: self.getFBfriendsArray)
               
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
                UtilityClass.showAlert(Message: msg)
                
                // For refreshing the Find Friends list
                let parent = self.parent as! InviteViewController
                for child in parent.children {
                    if child.isKind(of: FindFriendsViewController.self) {
                        let findFriendVC = child as! FindFriendsViewController
                        findFriendVC.retrieveContacts(from: findFriendVC.store)
                    }
                }
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
