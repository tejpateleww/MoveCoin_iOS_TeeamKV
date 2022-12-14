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
import SwiftyJSON
import FirebaseAnalytics
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
    
//    var facebookFriendsCount : Int {
//
//        get {
//            return self.facebookFriendsCount
//        }
//
//        set(newValue) {
//            self.facebookFriendsCount = newValue
//        }
//    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.logEvent("FacebookFriendsScreen", parameters: nil)

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
            if socialType == "facebook" && UserDefaults.standard.string(forKey: UserDefaultKeys.kFacebookID) == nil {
                
                // Store facebook ID if login with facebook
                UserDefaults.standard.set(SingletonClass.SharedInstance.userData?.socialID, forKey: UserDefaultKeys.kFacebookID)
            }
        }
        
        // Check Login type is facebook or nor
        if UserDefaults.standard.string(forKey: UserDefaultKeys.kFacebookID) != nil {
            tblFriends.isHidden = false
            btnFacebook.isHidden = true
            getFacebookFriendList()
        } else {
            tblFriends.isHidden = true
            btnFacebook.isHidden = false
        }
    }
    
    func getFBUserData() {
        
        var parameters = [AnyHashable: Any]()
        parameters["fields"] = "first_name, last_name, email, id, picture.type(large),friends"
        
        GraphRequest.init(graphPath: "me", parameters: parameters as! [String : Any]).start { (connection, result, error) in
            if error == nil {
                
                print("\(#function) \(result!)")
                let dictData = result as! [String : AnyObject]
                let strUserId = String(describing: dictData["id"]!)
                
                // Store facebook ID
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
        
        self.getFBfriendsArray = []
        
        var parameters = [AnyHashable: Any]()
        parameters["fields"] = "name,email,id,friends{first_name,last_name}"
        
//        guard let fbID = UserDefaults.standard.string(forKey: UserDefaultKeys.kFacebookID) else { return }

        let request = GraphRequest(graphPath: "me", parameters: parameters as! [String : Any], httpMethod: .get)
        request.start(completionHandler: { connection, result, error in
            // Insert your code here
            print("Friends Result: \(String(describing: result))")
            print("Friends connection: \(String(describing: connection))")
            print("Friends error: \(String(describing: error))")
            
            if error != nil {
                UtilityClass.hideHUD()
                return
            }
            
            guard let resultData = result as? [String : Any] else { return }
            let resultdict = resultData["friends"] as? [String : Any]
//            print("Result Dict: \(resultdict)")
            
            let friendsArray = resultdict?["data"] as? NSArray
            
            for friend in friendsArray ?? [] {
                let value = FacebookFriend(fromDictionary: friend as? [String : Any] ?? [:])
                self.getFBfriendsArray.append(value)
            }
            
//            if let summery = resultdict["summary"] as? NSDictionary {
//                self.facebookFriendsCount = summery["total_count"] as! Int
//            }
            
            self.btnFacebook.isHidden = true
            
            if let paging = resultdict?["paging"] as? NSDictionary {
//                print("Paging : \(paging)")
                if let nextURL = paging["next"] as? String {
                    if let url = URL(string: nextURL) {
                        self.webserivceForFacebookPagination(nextURL: url) { (isNext) in
                            print(isNext)
                            
                            if !isNext {
                                self.webserviceForInviteFriends(dic: self.getFBfriendsArray)
                            }
                        }
                    }
                } else {
                    self.webserviceForInviteFriends(dic: self.getFBfriendsArray)
                }
            } else {
                
                if self.getFBfriendsArray.count == 0 {
                    
                    self.refreshControl.endRefreshing()
                    self.tblFriends.isHidden = false
                    self.tblFriends.reloadData()
                } else {
                    self.webserviceForInviteFriends(dic: self.getFBfriendsArray)
                }
            }
        })
    }
    
    func showActionSheet(friendRequestID : String) {
        
        let alert = UIAlertController(title: nil, message: "Please Select an Option".localized, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Accept".localized, style: .default, handler: { (_) in
            self.webserviceForAcceptReject(requestID: friendRequestID, action: "Accept")
        }))

        alert.addAction(UIAlertAction(title: "Reject".localized, style: .default, handler: { (_) in
            self.webserviceForAcceptReject(requestID: friendRequestID,action: "Reject")
        }))

        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
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
            cell.textLabel?.font = UIFont.regular(ofSize: 30)
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
            if cell.fbFriend?.isFriend == "0" {
                webserviceForAddFriends(id: cell.fbFriend?.id ?? "")
            } else {
                if (cell.fbFriend?.isFriend == "1") && (cell.fbFriend?.senderID != SingletonClass.SharedInstance.userData?.iD ?? "") {
                    self.showActionSheet(friendRequestID: cell.fbFriend?.requestID ?? "")
                }
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
    
    func webserivceForFacebookPagination(nextURL : URL, completion: @escaping (Bool) -> Void) {
        
        WebService.shared.getMethod(url: nextURL, httpMethod: .get) { (result, success, obj) in
            
            print(result)
           
            let friendsArray = result["data"].arrayValue
            
            for friend in friendsArray {

                let value = FacebookFriend(fromDictionary: friend.dictionaryObject!)
                self.getFBfriendsArray.append(value)
            }
            
            if let paging = result["paging"].dictionaryObject {
                if let nextURL = paging["next"] as? String {
                    completion(true)
                    if let url = URL(string: nextURL) {
                        self.webserivceForFacebookPagination(nextURL: url) { (isNext) in
                            print(isNext)
                        }
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    
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
        requestModel.type = "0" // For Facebook

        FriendsWebserviceSubclass.friendRequest(friendRequestModel: requestModel){ (json, status, res) in
            
            if status {
                
//                self.webserviceForInviteFriends(dic: self.getFBfriendsArray)
               
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
                UtilityClass.showAlert(Message: msg)
                
                // For refreshing Friends list
                let parent = self.parent as! InviteViewController
                parent.refreshAllFriendsList()
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func webserviceForAcceptReject(requestID: String, action: String = "Reject"){
        
        UtilityClass.showHUD()
        
        let requestModel = ActionOnFriendRequestModel()
        requestModel.UserID = SingletonClass.SharedInstance.userData?.iD ?? ""
        requestModel.RequestID = requestID
        requestModel.Action = action

        FriendsWebserviceSubclass.actionOnFriendRequest(actionFriendRequestModel: requestModel){ (json, status, res) in
            UtilityClass.hideHUD()
            if status {
                // For refreshing Friends list
                let parent = self.parent as! InviteViewController
                parent.refreshAllFriendsList()
                
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
                UtilityClass.showAlert(Message: msg)
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
