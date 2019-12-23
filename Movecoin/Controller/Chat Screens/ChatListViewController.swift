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
    
    @IBOutlet weak var tblChatList: UITableView!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    lazy var friendsArray = [ChatList]()
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        webserviceForChatList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpNavigationItems()
        self.navigationBarSetUp(title: "Chats")
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        self.tblChatList.delegate = self
        self.tblChatList.dataSource = self
        self.tblChatList.tableFooterView = UIView.init(frame: CGRect.zero)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "ChatStoryboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
        let data = friendsArray[indexPath.row]
        let dic : [String : String] = ["id" : data.iD, "fullname" : data.fullName, "profilePicture" : data.profilePicture]
        controller.userData = dic
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func ChatFromNotification(dict: [String:Any]) {
        let storyBoard = UIStoryboard(name: "ChatStoryboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
        let data = dict
        let dic : [String : String] = ["id" : data["SenderID"] as? String ?? "", "fullname" : data["sender_name"] as? String ?? "", "profilePicture" : ""]
        controller.userData = dic
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension ChatListViewController {
    
    func webserviceForChatList(){
        
        UtilityClass.showHUD()
         
        let requestModel = ChatListModel()
        requestModel.user_id = SingletonClass.SharedInstance.userData?.iD ?? ""
    
        FriendsWebserviceSubclass.chatList(chatListModel: requestModel){ (json, status, res) in
            
            UtilityClass.hideHUD()
            if status {
                let responseModel = ChatListResponseModel(fromJson: json)
                if responseModel.chatList.count > 0  {
                    self.friendsArray = responseModel.chatList
                    self.tblChatList.reloadData()
                }
            } 
        }
    }
}

