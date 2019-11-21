//
//  FriendsViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var tblFriends: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    
    lazy var friendsArray : [FriendDetail] = []
    lazy var friendListType = FriendsList.FollowUnfollow
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
        let friend1 = FriendDetail(name: "Muhammad", number: "@mohammad362")
        let friend2 = FriendDetail(name: "Mustapha", number: "@mustapha5412")
        let friend3 = FriendDetail(name: "Muhammad", number: "@mohammad362")
        let friend4 = FriendDetail(name: "Mustapha", number: "@mustapha5412")
        let friend5 = FriendDetail(name: "Muhammad", number: "@mohammad362")
        let friend6 = FriendDetail(name: "Mustapha", number: "@mustapha5412")
        let friend7 = FriendDetail(name: "Muhammad", number: "@mohammad362")
        let friend8 = FriendDetail(name: "Mustapha", number: "@mustapha5412")
        let friend9 = FriendDetail(name: "Muhammad", number: "@mohammad362")
        let friend10 = FriendDetail(name: "Mustapha", number: "@mustapha5412")
        friendsArray = [friend1,friend2,friend3,friend4,friend5,friend6,friend7,friend8,friend9,friend10]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(isHidden: false, title: "Friends", hidesBackButton: false)
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        self.tblFriends.delegate = self
        self.tblFriends.dataSource = self
        self.tblFriends.tableFooterView = UIView.init(frame: CGRect.zero)
        
        txtSearch.font = UIFont.regular(ofSize: 15)
    }
}

extension FriendsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.className) as! FriendTableViewCell
        cell.selectionStyle = .none
        cell.listType = friendListType
        cell.friendDetail = friendsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = friendListType
        
        switch type {
        case .NewChat:
            let chatStoryboard = UIStoryboard(name: "ChatStoryboard", bundle: nil)
            let destination = chatStoryboard.instantiateViewController(withIdentifier: ChatViewController.className) as! ChatViewController
            self.navigationController?.pushViewController(destination, animated: true)
            break
        default:
            return
        }
    }
}

