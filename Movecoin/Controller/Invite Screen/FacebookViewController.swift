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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getFacebookFriendList), for: .valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
//        lblDescription.font = UIFont.regular(ofSize: 15)
    }
    
    // ----------------------------------------------------
    //MARK:- --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        tblFriends.delegate = self
        tblFriends.dataSource = self
        tblFriends.tableFooterView = UIView.init(frame: CGRect.zero)
        tblFriends.addSubview(refreshControl)
        
        if let socialType = SingletonClass.SharedInstance.userData?.socialType {
            if socialType == "facebook" && UserDefaults.standard.string(forKey: UserDefaultKeys.kFacebookID) == nil { // SingletonClass.SharedInstance.facebookID == nil {
                
                // Store facebook ID if login with facebook
//                SingletonClass.SharedInstance.facebookID = SingletonClass.SharedInstance.userData?.socialID
                UserDefaults.standard.set(SingletonClass.SharedInstance.userData?.socialID, forKey: UserDefaultKeys.kFacebookID)
                
            }
        }
        
        // Check Login type is facebook or nor
        if let fbID = UserDefaults.standard.string(forKey: UserDefaultKeys.kFacebookID) {
            tblFriends.isHidden = false
            btnFacebook.isHidden = true
            getFacebookFriendList()
        } else {
            tblFriends.isHidden = true
            btnFacebook.isHidden = false
        }
        
//        if let socialType = SingletonClass.SharedInstance.userData?.socialType {
//            if socialType == "facebook" {
//                btnFacebook.isHidden = true
//                getFacebookFriendList()
//            } else {
//               btnFacebook.isHidden = false
//            }
//        } else {
//            btnFacebook.isHidden = false
//        }
    }
    
    func getFBUserData() {
        
        var parameters = [AnyHashable: Any]()
        parameters["fields"] = "first_name, last_name, email, id"
        
        GraphRequest.init(graphPath: "me", parameters: parameters as! [String : Any]).start { (connection, result, error) in
            if error == nil {
                
                print("\(#function) \(result!)")
                let dictData = result as! [String : AnyObject]
            
                let strUserId = String(describing: dictData["id"]!)
                
                // Store facebook ID
//                SingletonClass.SharedInstance.facebookID = strUserId
                UserDefaults.standard.set(strUserId, forKey: UserDefaultKeys.kFacebookID)
                
                self.getFacebookFriendList()
            }
            else{
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    @objc func getFacebookFriendList() {
        
//        UtilityClass.showHUD()
        
        var parameters = [AnyHashable: Any]()
        parameters["fields"] = "first_name, last_name, email, id"
        
        guard let fbID = UserDefaults.standard.string(forKey: UserDefaultKeys.kFacebookID) else { return }
        
        let request = GraphRequest(graphPath: "/\(fbID)/friends", parameters: parameters as! [String : Any], httpMethod: .get)
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
            
            self.btnFacebook.isHidden = true
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
        
        //        if let socialType = SingletonClass.SharedInstance.userData?.socialType {
        //            if socialType != "facebook" {
        
        if !WebService.shared.isConnected {
            UtilityClass.showAlert(Message: "Please check your internet".localized)
            return
        }
        let login = LoginManager()
        login.logOut()
        login.logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
            
            if error != nil {
                
            }
            else if (result?.isCancelled)! {
                
            }else {
                if (result?.grantedPermissions.contains("email"))! {
                    
                    self.getFBUserData()
                }else {
                    print("you don't have permission")
                }
            }
        }
    }
}


// ----------------------------------------------------
//MARK:- --------- TableView Methods ---------
// ----------------------------------------------------

extension FacebookViewController : UITableViewDelegate, UITableViewDataSource, InviteFriendCellDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return fbFriendsArray.count > 0 ? 55 : tableView.frame.height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fbFriendsArray.count > 0 ? fbFriendsArray.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if fbFriendsArray.count > 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: FindFriendTableViewCell.className) as! FindFriendTableViewCell
            cell.selectionStyle = .none
            cell.cellDelegate = self
            
            cell.type = FriendsStatus.init(rawValue: "Recommended")
            DispatchQueue.main.async {
                switch cell.type {
                    
                case .RecommendedFriend:
                    
                    cell.fbFriend = self.fbFriendsArray[indexPath.row]
                    
                default:
                    break
                }
            }
            return cell
            
        } else {
        
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.backgroundColor = .clear
            cell.textLabel?.text = "No friends from facebook to add".localized
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.bold(ofSize: 30)
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            
            return cell
        }
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
            self.refreshControl.endRefreshing()
            
            if status {
                
                let responseModel = SocialUserResponseModel(fromJson: json)
//                self.notFriendsArray = responseModel.notFriend
                self.fbFriendsArray = responseModel.users
                self.tblFriends.isHidden = false
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
