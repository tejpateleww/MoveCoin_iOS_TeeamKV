//
//  ChatListViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var tblChatList: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    lazy var friendsArray = [ChatList]()
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        localizeUI(parentView: self.viewParent)
        self.setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpNavigationItems()
        self.navigationBarSetUp(title: "Chats")
        webserviceForChatList()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        self.tblChatList.delegate = self
        self.tblChatList.dataSource = self
        self.tblChatList.tableFooterView = UIView.init(frame: CGRect.zero)
        lblNoDataFound.isHidden = true
        lblNoDataFound.text = "No chats available".localized
    }
    
    func setUpNavigationItems(){
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "chatadd-icon"), style: .plain, target: self, action: #selector(btnNewChatTapped))
        self.navigationItem.setRightBarButtonItems([rightBarButton], animated: true)
    }
    
    @objc func btnNewChatTapped(){
        let destination = self.storyboard?.instantiateViewController(withIdentifier: FriendsViewController.className) as! FriendsViewController
        destination.friendListType = FriendsList.NewChat
        self.navigationController?.pushViewController(destination, animated: true)
    }
}

// ----------------------------------------------------
//MARK:- --------- Tableview Delegate Methods ---------
// ----------------------------------------------------

extension ChatListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTableViewCell.className) as! ChatListTableViewCell
        cell.selectionStyle = .none
        cell.friendDetail = friendsArray[indexPath.row]
//        localizeUI(parentView: cell.contentView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "ChatStoryboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
        let data = friendsArray[indexPath.row]
        controller.receiverID = data.iD
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let alert = UIAlertController(title: kAppName.localized, message: "Are you sure you want to delete the chat?".localized, preferredStyle: .alert)
            let btnOk = UIAlertAction(title: "OK".localized, style: .default) { (action) in
                let data = self.friendsArray[indexPath.row]
                self.webserviceForDeleteChat(friendID: data.iD)
            }
            let btncancel = UIAlertAction(title: "Cancel".localized, style: .default) { (cancel) in
                self.dismiss(animated: true, completion:nil)
            }
            alert.addAction(btnOk)
            alert.addAction(btncancel)
            alert.modalPresentationStyle = .overCurrentContext
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func ChatFromNotification(dict: [String:Any]) {
        let storyBoard = UIStoryboard(name: "ChatStoryboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
        controller.receiverID = dict["SenderID"] as? String
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension ChatListViewController {
    
    func webserviceForChatList(){
        
    let requestModel = ChatListModel()
        requestModel.user_id = SingletonClass.SharedInstance.userData?.iD ?? ""
    
        FriendsWebserviceSubclass.chatList(chatListModel: requestModel){ (json, status, res) in

            if status {
                let responseModel = ChatListResponseModel(fromJson: json)
                if responseModel.chatList.count > 0  {
                    self.friendsArray = responseModel.chatList
                    self.tblChatList.reloadData()
                    self.lblNoDataFound.isHidden = true
                }else{
                    self.lblNoDataFound.isHidden = false
                }
            } 
        }
    }
    
    func webserviceForDeleteChat(friendID : String){
        let requestModel = ChatClearModel()
        requestModel.user_id = SingletonClass.SharedInstance.userData?.iD ?? ""
        requestModel.friend_id = friendID
        
        UtilityClass.showHUD()
        FriendsWebserviceSubclass.chatClear(chatClearModel: requestModel){ (json, status, res) in
            
            UtilityClass.hideHUD()
            if status {
                let responseModel = ChatListResponseModel(fromJson: json)
                self.friendsArray = responseModel.chatList
                self.tblChatList.reloadData()
                if responseModel.chatList.count > 0  {
                    self.lblNoDataFound.isHidden = true
                }else{
                    self.lblNoDataFound.isHidden = false
                }
            }
        }
    }
}

