//
//  BlockedListViewController.swift
//  Movecoins
//
//  Created by EWW071 on 07/10/20.
//  Copyright © 2020 eww090. All rights reserved.
//

import UIKit

class BlockedListViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var tblBlockList: UITableView!
//    @IBOutlet weak var lblNoDataFound: UILabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var blockList : [List]?
    lazy var friendListType = FriendsList.BlockList
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        webserviceForBlockedList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(title: "Block List".localized)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        self.tblBlockList.delegate = self
        self.tblBlockList.dataSource = self
        self.tblBlockList.tableFooterView = UIView.init(frame: CGRect.zero)
        
//        lblNoDataFound.isHidden = true
    }
}

// ----------------------------------------------------
//MARK:- --------- Tableview Delegate Methods ---------
// ----------------------------------------------------

extension BlockedListViewController : UITableViewDelegate, UITableViewDataSource, FriendCellDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.className) as! FriendTableViewCell
        cell.selectionStyle = .none
        cell.listType = friendListType 
        cell.cellDelegate = self
        cell.blockUserDetail = blockList?[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func didPressButton(_ cell: FriendTableViewCell) {
        print(cell.listType)
        
        switch cell.listType {
            
        case .BlockList:
            print("Unblock")
//            let msg = ""
//            let alert = UIAlertController(title: kAppName.localized, message: "Are you sure want to remove ".localized + (cell.friendDetail?.fullName ?? "") + " as your friend?".localized, preferredStyle: .alert)
//            let btnOk = UIAlertAction(title: "OK".localized, style: .default) { (action) in
                self.webserviceForUnblock(id: cell.blockUserDetail?.id ?? "")
//            }
//            let btncancel = UIAlertAction(title: "Cancel".localized, style: .default) { (cancel) in
//                self.dismiss(animated: true, completion:nil)
//            }
//            alert.addAction(btnOk)
//            alert.addAction(btncancel)
//            alert.modalPresentationStyle = .overCurrentContext
//            self.present(alert, animated: true, completion: nil)
            
        default:
            print("Default")
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension BlockedListViewController {
    
    func webserviceForBlockedList(){
        
        UtilityClass.showHUD()
           
        let requestModel = BlockList()
        requestModel.block_by = SingletonClass.SharedInstance.userData?.iD ?? ""
    
        UserWebserviceSubclass.blockList(requestModel: requestModel) { (json, status, res) in
            
            UtilityClass.hideHUD()
            if status {
                let responseModel = BlockListResponseModel(fromJson: json)
//                if responseModel.list.count > 0  {
                    self.blockList = responseModel.list
                    self.tblBlockList.reloadData()
//                }
            }
        }
    }
    
    func webserviceForUnblock(id : String){
        
        UtilityClass.showHUD()
           
        let requestModel = UnblockUser()
        requestModel.block_id = id
    
        UserWebserviceSubclass.unblockUser(requestModel: requestModel) { (json, status, res) in
            
            UtilityClass.hideHUD()
            if status {
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
                UtilityClass.showAlert(Message: msg)
                self.webserviceForBlockedList()
                
            } else {
                
            }
        }
    }
}
