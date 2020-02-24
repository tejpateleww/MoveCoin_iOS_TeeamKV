//
//  FriendsViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

struct FriendDetail {
    var name : String
    var number : String
}

class FriendsViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var tblFriends: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    lazy var search : String = ""
    lazy var friendsArray : [FriendsData] = []
    lazy var searchArray : [FriendsData] = []
    lazy var friendListType = FriendsList.Unfriend
    lazy var isTyping: Bool = false
   
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        localizeUI(parentView: self.viewParent)
        self.setUpView()
        webserviceForFriendsList(isLoading: true)
        lblNoDataFound.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(title: "Friends")
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        self.tblFriends.delegate = self
        self.tblFriends.dataSource = self
        self.tblFriends.tableFooterView = UIView.init(frame: CGRect.zero)
        
        txtSearch.font = UIFont.regular(ofSize: 15)
        lblNoDataFound.text = "You didn't connect with your friends".localized
    }
    
    // ----------------------------------------------------
    //MARK:- --------- UItextfield Action Methods ---------
    // ----------------------------------------------------
    
    @IBAction func txtSearchEditingChangedAction(_ sender: UITextField) {
        let enteredText = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        isTyping = (enteredText?.isEmpty ?? false) ? false : true
        searchArray = friendsArray.filter{ $0.fullName.lowercased().contains(enteredText?.lowercased() ?? "") || $0.nickName.lowercased().contains(enteredText?.lowercased() ?? "")}
        tblFriends.reloadData()
//        let isZero = isTyping ? searchArray.count == 0 : friendsArray.count == 0
//        if isZero {
//            lblNoDataFound.isHidden = false
//        }else{
//            lblNoDataFound.isHidden = true
//        }
    }
}

// ----------------------------------------------------
//MARK:- --------- Tableview Delegate Methods ---------
// ----------------------------------------------------

extension FriendsViewController : UITableViewDelegate, UITableViewDataSource, FriendCellDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isTyping ? searchArray.count : friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.className) as! FriendTableViewCell
        cell.selectionStyle = .none
        cell.listType = friendListType
        cell.cellDelegate = self
        cell.friendDetail = isTyping ? searchArray[indexPath.row] : friendsArray[indexPath.row]
//        localizeUI(parentView: cell.contentView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       switch friendListType {
       case .NewChat, .Unfriend:
                let chatStoryboard = UIStoryboard(name: "ChatStoryboard", bundle: nil)
                let destination = chatStoryboard.instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
                let data = isTyping ? searchArray[indexPath.row] : friendsArray[indexPath.row]
                destination.receiverID = data.iD
                self.navigationController?.pushViewController(destination, animated: true)
                   
            default:
                return
        }
       
    }
    
    func didPressButton(_ cell: FriendTableViewCell) {
        print(cell.listType)
        
        switch cell.listType {
                   
            case .TransferCoins:
                print("Send")
                let destination = self.storyboard?.instantiateViewController(withIdentifier: TransferMoveCoinsViewController.className) as! TransferMoveCoinsViewController
                destination.receiverID = cell.friendDetail?.iD
                destination.receiverName = cell.friendDetail?.fullName
                self.navigationController?.pushViewController(destination, animated: true)
                   
            case .Unfriend:
                print("Unfriend")
                let alert = UIAlertController(title: kAppName.localized, message: "Are you sure want to remove ".localized + (cell.friendDetail?.fullName ?? "") + " as your friend?".localized, preferredStyle: .alert)
                let btnOk = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.webserviceForUnfriend(id: cell.friendDetail?.iD ?? "")
                }
                let btncancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
                    self.dismiss(animated: true, completion:nil)
                }
                alert.addAction(btnOk)
                alert.addAction(btncancel)
                alert.modalPresentationStyle = .overCurrentContext
                self.present(alert, animated: true, completion: nil)
            
            case .NewChat:
                print("NewChat")
        }
    }
}


// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension FriendsViewController {
    
    func webserviceForFriendsList(isLoading: Bool){
        
        if isLoading {
            UtilityClass.showHUD()
        }
            
        let requestModel = FriendListModel()
        requestModel.SenderID = SingletonClass.SharedInstance.userData?.iD ?? ""
    
        FriendsWebserviceSubclass.friendsList(frinedListModel: requestModel){ (json, status, res) in
            
            UtilityClass.hideHUD()
            if status {
                let responseModel = FriendsResponseModel(fromJson: json)
                if responseModel.friendList.count == 0  {
                    self.tblFriends.isHidden = true
                    self.lblNoDataFound.isHidden = false
                }else{
                    self.tblFriends.isHidden = false
                    self.lblNoDataFound.isHidden = true
                    self.friendsArray = responseModel.friendList
                    self.searchArray = self.friendsArray
                    self.tblFriends.reloadData()
                }
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func webserviceForUnfriend(id: String){
        
        UtilityClass.showHUD()
               
        let requestModel = UnfriendModel()
        requestModel.UserID = SingletonClass.SharedInstance.userData?.iD ?? ""
        requestModel.FriendID = id
    
        FriendsWebserviceSubclass.unfriend(unfrinedModel: requestModel){ (json, status, res) in
            
            UtilityClass.hideHUD()
            if status {
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
                UtilityClass.showAlert(Message: msg)
                self.webserviceForFriendsList(isLoading: false)
                
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}

