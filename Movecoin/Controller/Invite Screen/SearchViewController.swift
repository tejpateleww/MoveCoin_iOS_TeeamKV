//
//  SearchViewController.swift
//  Movecoins
//
//  Created by EWW071 on 12/08/20.
//  Copyright © 2020 eww090. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

   // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var tblFriends: UITableView!
    @IBOutlet weak var txtSearch: TextFieldFont!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    private var lastSearchTxt = ""
    lazy var searchArray : [SearchData] = []
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        tblFriends.delegate = self
        tblFriends.dataSource = self
        tblFriends.tableFooterView = UIView.init(frame: CGRect.zero)
        
        txtSearch.delegate = self
    }
    
    func showActionSheet(cell: FindFriendTableViewCell) {
        
        let alert = UIAlertController(title: nil, message: "Please Select an Option".localized, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Accept".localized, style: .default, handler: { (_) in
            self.webserviceForAcceptReject(requestID: cell.searchFriend?.requestID ?? "", action: "Accept", cell: cell)
        }))

        alert.addAction(UIAlertAction(title: "Reject".localized, style: .default, handler: { (_) in
            self.webserviceForAcceptReject(requestID: cell.searchFriend?.requestID ?? "", action: "Reject", cell: cell)
        }))

        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}

// ----------------------------------------------------
//MARK:- --------- TextField Delegate Methods ---------
// ----------------------------------------------------

extension SearchViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange, with: string)
           if lastSearchTxt.isEmpty {
               lastSearchTxt = updatedText
           }
           NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.webserviceForSearch), object: lastSearchTxt)
           lastSearchTxt = updatedText
           self.perform(#selector(self.webserviceForSearch), with: updatedText, afterDelay: 0.7)
        }
        
        return true
    }
}

// ----------------------------------------------------
//MARK:- --------- TableView Methods ---------
// ----------------------------------------------------

extension SearchViewController : UITableViewDelegate, UITableViewDataSource, InviteFriendCellDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FindFriendTableViewCell.className) as! FindFriendTableViewCell
        cell.selectionStyle = .none
        cell.cellDelegate = self
        
        cell.type = FriendsStatus.init(rawValue: "Recommended")
        DispatchQueue.main.async {
            switch cell.type {
            case .RecommendedFriend:
                
                cell.searchFriend = self.searchArray[indexPath.row]
                cell.tag = indexPath.row
                
            default:
                break
            }
        }
        return cell
    }
    
    func didPressButton(_ cell: FindFriendTableViewCell) {
        switch cell.type {
            
        case .RecommendedFriend:
            if cell.searchFriend?.isFriend == "0" {
                webserviceForAddFriends(id: cell.searchFriend?.iD ?? "", cell: cell)
            } else {
                if (cell.searchFriend?.isFriend == "1") && (cell.searchFriend?.senderID != SingletonClass.SharedInstance.userData?.iD ?? "") {
                    self.showActionSheet(cell: cell)
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


extension SearchViewController {
    
    @objc private func webserviceForSearch(searchText : String){
        
         print("\(searchText)")
        
        if searchText.isBlank {
            self.searchArray = []
            self.tblFriends.reloadData()
            return
        }
        
        UtilityClass.showHUD()
        self.txtSearch.endEditing(true)
        
        let requestModel = SearchRequestModel()
        requestModel.search_str = searchText
        requestModel.user_id = SingletonClass.SharedInstance.userData?.iD ?? ""

        FriendsWebserviceSubclass.searchFriend(searchRequestModel: requestModel){ (json, status, res) in

            UtilityClass.hideHUD()
            if status {
               let response = SearchFriendResponseModel(fromJson: json)
                self.searchArray = response.result
                DispatchQueue.main.async {
                    self.tblFriends.reloadData()
                }
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func webserviceForAddFriends(id : String, cell: FindFriendTableViewCell){
        
        let requestModel = FriendRequestModel()
        requestModel.SenderID = SingletonClass.SharedInstance.userData?.iD ?? ""
        requestModel.ReceiverID = id
        requestModel.type = "2" // For Search

        FriendsWebserviceSubclass.friendRequest(friendRequestModel: requestModel){ (json, status, res) in
            
            if status {
                
                let response = FriendRequestResponseModel(fromJson: json)
                
                cell.searchFriend?.senderID = response.data.senderID
                cell.searchFriend?.isFriend = "1" // Requested
                DispatchQueue.main.async {
                    self.tblFriends.reloadData()
                }
                
                // For refreshing Friends list
                let parent = self.parent as! InviteViewController
                parent.refreshAllFriendsList()
                
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? response.message : response.arabicMessage
                UtilityClass.showAlert(Message: msg ?? "")
                
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func webserviceForAcceptReject(requestID: String, action: String = "Reject", cell: FindFriendTableViewCell){
        
        UtilityClass.showHUD()
        
        let requestModel = ActionOnFriendRequestModel()
        requestModel.UserID = SingletonClass.SharedInstance.userData?.iD ?? ""
        requestModel.RequestID = requestID
        requestModel.Action = action

        FriendsWebserviceSubclass.actionOnFriendRequest(actionFriendRequestModel: requestModel){ (json, status, res) in
            UtilityClass.hideHUD()
            if status {
                
                if action == "Accept" {
                   self.searchArray.remove(at: cell.tag)
                } else {
                    cell.searchFriend?.isFriend = "0" // Add Friend
                }
                
                DispatchQueue.main.async {
                    self.tblFriends.reloadData()
                }
                
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
