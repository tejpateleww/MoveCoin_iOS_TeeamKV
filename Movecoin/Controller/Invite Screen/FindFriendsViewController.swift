//
//  FindFriendsViewController.swift
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

class FindFriendsViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var tblFriends: UITableView!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    
    var friendsArray : [FriendDetail] = []
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
        let friend1 = FriendDetail(name: "Muhammad", number: "+971 6584 69584")
        let friend2 = FriendDetail(name: "Mustapha", number: "+971 6584 69584")
        let friend3 = FriendDetail(name: "Kashif", number: "+971 6584 69584")
        let friend4 = FriendDetail(name: "Sarah", number: "+971 6584 69584")
        let friend5 = FriendDetail(name: "Leen", number: "+971 6584 69584")
        let friend6 = FriendDetail(name: "Lashiya", number: "+971 6584 69584")
        let friend7 = FriendDetail(name: "Ayesha", number: "+971 6584 69584")
        let friend8 = FriendDetail(name: "Halum", number: "+971 6584 69584")
        let friend9 = FriendDetail(name: "Sumeya", number: "+971 6584 69584")
        let friend10 = FriendDetail(name: "Muhammad", number: "+971 6584 69584")
        friendsArray = [friend1,friend2,friend3,friend4,friend5,friend6,friend7,friend8,friend9,friend10]
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        tblFriends.delegate = self
        tblFriends.dataSource = self
        tblFriends.tableFooterView = UIView.init(frame: CGRect.zero)
    }
}

extension FindFriendsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FindFriendTableViewCell.className) as! FindFriendTableViewCell
        cell.selectionStyle = .none
        cell.friendDetail = friendsArray[indexPath.row]
        return cell
    }
}
