//
//  FindFriendsViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import Contacts
import MessageUI
import IQKeyboardManagerSwift
import FirebaseAnalytics


class FriendsTableData {
    var SectionTitle : String!
    var Rows : [Any]!
    
    init(section:String, rows:[Any]){
        self.SectionTitle = section
        self.Rows = rows
    }
}

class FindFriendsViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var tblFriends: UITableView!
    @IBOutlet weak var txtSearch: TextFieldFont!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    lazy var contactsArray : [PhoneModel] = []
    lazy var notRegisteredContacts : [PhoneModel] = []
    lazy var registeredContacts : [Registered] = []
    var responseModel : InviteFriendsResponseModel?
    let store = CNContactStore()
    lazy var tableData : [FriendsTableData] = []
    
    private var lastSearchTxt = ""
    lazy var isTyping: Bool = false
    lazy var isSearchData: Bool = false
    lazy var searchArray : [FriendsTableData] = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(accessContacts), for: .valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        accessContacts()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.logEvent("FindFriendsScreen", parameters: nil)

    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setUpView(){
        // for hiding toolbar of keyboard
        txtSearch.inputAccessoryView = UIView()
        
        txtSearch.delegate = self
        txtSearch.returnKeyType = .search
        
        // Tableview setup
        tblFriends.delegate = self
        tblFriends.dataSource = self
        tblFriends.tableFooterView = UIView.init(frame: CGRect.zero)
        tblFriends.addSubview(refreshControl)
//        tblFriends.estimatedRowHeight = 65
//        tblFriends.rowHeight = UITableView.automaticDimension
    }
    
    @objc func accessContacts(){
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        if authorizationStatus == .notDetermined {

            store.requestAccess(for: .contacts) { [weak self] didAuthorize,
            error in
                if didAuthorize {
                    self?.retrieveContacts(from: self!.store)
                } else {
                    self?.webserviceForInviteFriends(dic: self!.contactsArray)
                }
            }
        } else if authorizationStatus == .authorized {
            isSearchData = false
            searchArray.removeAll()
            isTyping = false
            retrieveContacts(from: store)
        } else {
            webserviceForInviteFriends(dic: contactsArray)
        }
    }
    
    func retrieveContacts(from store: CNContactStore) {
   
      let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                         CNContactFamilyNameKey as CNKeyDescriptor,
                         CNContactPhoneNumbersKey as CNKeyDescriptor]
       let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        do {
            try store.enumerateContacts(with: request){
                    (contact, stop) in
                // Array containing all unified contacts from everywhere
               
                for phoneNumber in contact.phoneNumbers {
                    let number = phoneNumber.value
                    let digits = number.stringValue.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                    if digits.count >= 9 {
                        let name = contact.givenName + " " + contact.familyName
                        let phone = PhoneModel(name: name.trimmingCharacters(in: .whitespacesAndNewlines), number: String(digits)) //.suffix(10)))
                        self.contactsArray.append(phone)
                    }
                }
            }
//            if contactsArray.count >= 1 {
                webserviceForInviteFriends(dic: contactsArray)
//            }
        } catch {
            print("unable to fetch contacts")
            webserviceForInviteFriends(dic: contactsArray)
        }
    }
    
    @objc private func reloadTableForSearch(searchText : String) {
        print("reloadTableForSearch : \(searchText)")
        
        self.txtSearch.endEditing(true)
        isTyping = false
        
        if searchText.isBlank {
            // For displaying original data while textfield has no data
            UtilityClass.hideHUD()
            tblFriends.reloadData()
            return
        } else {
            // For handling crash put loader for delay refreshing table
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                UtilityClass.hideHUD()
                self.isTyping = true
                self.filterSearchListFor(searchText: searchText)
                self.tblFriends.reloadData()
            }
        }
    }
    
    func filterSearchListFor(searchText : String){
        searchArray.removeAll()
        
        let req = (tableData.filter{$0.SectionTitle == "Requested"}.first?.Rows as? [Request])?.filter{$0.fullName.lowercased().contains(searchText.lowercased() ) || $0.nickName.lowercased().contains(searchText.lowercased() )}
        
        let reco = (tableData.filter{$0.SectionTitle == "Recommended"}.first?.Rows as? [Registered])?.filter{$0.fullName.lowercased().contains(searchText.lowercased() ) || $0.nickName.lowercased().contains(searchText.lowercased() )}
        
        let notReq = (tableData.filter{$0.SectionTitle == "Not Registered"}.first?.Rows as? [PhoneModel])?.filter{$0.name.lowercased().contains(searchText.lowercased() ) }
        
        if let data = req, data.count != 0 {
            searchArray.append(FriendsTableData(section: "Requested", rows: data))
        }
        if let data = reco, data.count != 0 {
            searchArray.append(FriendsTableData(section: "Recommended", rows: data))
        }
        if let data = notReq, data.count != 0 {
            searchArray.append(FriendsTableData(section: "Not Registered", rows: data))
        }
    }
    
    // ----------------------------------------------------
    //MARK:- --------- Button Action Method ---------
    // ----------------------------------------------------
    
    @objc func btnAcceptTapped(_ sender: UIButton){
        
        if (sender.titleLabel?.text == "Accept".localized) {
            print("Accept")
            if let data = tableData.first?.Rows[sender.tag] as? Request {
                webserviceForAcceptReject(requestID: data.iD, action: "Accept")
            }
        }
    }
    
    // ----------------------------------------------------
    //MARK:- --------- TextDidChange Method ---------
    // ----------------------------------------------------
    
    @IBAction func txtSearchEditingChangedAction(_ sender: UITextField) {
        
        // For handling type and reload tableview with original data if no text in search textfield
        let enteredText = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        isTyping = (enteredText?.isEmpty ?? false) ? false : true
        if !isTyping {
            tblFriends.reloadData()
        }
//       reloadTableForSearch(searchText: enteredText)
    }
}

// ----------------------------------------------------
//MARK:- --------- TableView Methods ---------
// ----------------------------------------------------

extension FindFriendsViewController : UITableViewDelegate, UITableViewDataSource, InviteFriendCellDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        let sectionData = isSearchData ? searchArray[indexPath.section] : tableData[indexPath.section]
        let type = FriendsStatus.init(rawValue: sectionData.SectionTitle)
        switch type {
        case .RequestPendding:
            return 65 //UITableView.automaticDimension
        case .RecommendedFriend:
            return 65
        default:
            return 55
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("numberOfSections for seach : \(isSearchData)")
        return isSearchData ? searchArray.count : tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = isSearchData ? searchArray[section] : tableData[section]
        return sectionData.Rows.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionData = isSearchData ? searchArray[section] : tableData[section]
        return sectionData.SectionTitle.localized
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
       if let headerView = view as? UITableViewHeaderFooterView {
           headerView.contentView.backgroundColor = .white
           headerView.textLabel?.textColor = ThemeBlueColor
       }
   }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FindFriendTableViewCell.className) as! FindFriendTableViewCell
        cell.selectionStyle = .none
        cell.cellDelegate = self
        
        if isSearchData && searchArray.count == 0 {
            print("Search data is blank")
            
        }
        let sectionData = isSearchData ? searchArray[indexPath.section] : tableData[indexPath.section]
        cell.type = FriendsStatus.init(rawValue: sectionData.SectionTitle)
        DispatchQueue.main.async {
            switch cell.type {
            case .RequestPendding:
                if let requestData = sectionData.Rows[indexPath.row] as? Request {
                    cell.requested = requestData
                    if requestData.receiverID == SingletonClass.SharedInstance.userData?.iD {
                        cell.btnAccept.tag = indexPath.row
                        cell.btnAccept.addTarget(self, action: #selector(self.btnAcceptTapped(_:)), for: .touchUpInside)
                    }
                }
                
            case .RecommendedFriend:
                //            cell.registeredFriend = registeredContacts[indexPath.row]
                cell.registeredFriend = self.isSearchData ? self.searchArray[indexPath.section].Rows[indexPath.row] as! Registered : self.registeredContacts[indexPath.row]
                
            case .NotRegistedFriend:
                //           cell.notRegisteredFriend = notRegisteredContacts[indexPath.row]
                cell.notRegisteredFriend = self.isSearchData ? self.searchArray[indexPath.section].Rows[indexPath.row] as! PhoneModel : self.notRegisteredContacts[indexPath.row]
                
            default:
                break
            }
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")

        // For handling crash while tableview is scrolling and user search
        if isTyping {
            isSearchData = isTyping
        }
    }
    
    
    func didPressButton(_ cell: FindFriendTableViewCell) {
        switch cell.type {
        case .RequestPendding:
            if let id = cell.requested?.iD {
                webserviceForAcceptReject(requestID: id)
            }
            
        case .RecommendedFriend:
            if let recevierID = cell.registeredFriend?.iD {
                webserviceForAddFriends(id: recevierID)
            }
            
        case .NotRegistedFriend:
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            guard let number = cell.notRegisteredFriend?.number else { return }
            composeVC.recipients = [number]
            composeVC.body = "Check out this app ".localized + kAppName.localized + ", referral code - ".localized + (SingletonClass.SharedInstance.userData?.referralCode ?? "") + appURL
           // Present the view controller modally.
           if MFMessageComposeViewController.canSendText() {
               self.present(composeVC, animated: true, completion: nil)
           }
            
        default:
            break
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- TextField Delegate Methods ---------
// ----------------------------------------------------

extension FindFriendsViewController : UITextFieldDelegate {
    
    // For search when tap on search button in keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UtilityClass.showHUD()
        isTyping = true
        reloadTableForSearch(searchText: txtSearch.text ?? "")
        return true
    }
    
    // For detecting search data display or not
    func textFieldDidEndEditing(_ textField: UITextField) {
        isSearchData = (txtSearch.text?.isEmpty ?? false) ? false : true
        print("textFieldDidEndEditing isSearchData : \(isSearchData)")
        tblFriends.reloadData()
    }
    
    /*  --------  Uncomment for search while typing  ---------
     
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        isTyping = true

        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange, with: string)
           if lastSearchTxt.isEmpty {
               lastSearchTxt = updatedText
           }
           NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reloadTableForSearch(searchText:)), object: lastSearchTxt)
           lastSearchTxt = updatedText
           self.perform(#selector(self.reloadTableForSearch(searchText:)), with: updatedText, afterDelay: 0.7)
        }
        
        return true
    }
 */
}

// ----------------------------------------------------
//MARK:- --------- Messagae Delegate Methods ---------
// ----------------------------------------------------

extension FindFriendsViewController : MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension FindFriendsViewController {
    
    func webserviceForInviteFriends(dic : [PhoneModel]) {
        
        DispatchQueue.main.async {
            self.txtSearch.text = ""
        }
        isSearchData = false
        
        // JSON String for Sending Contacts
        var JSONstring = String()
        if let contactsDic = dic.asDictionaryArray {
            if let JSONData = try?  JSONSerialization.data(withJSONObject: contactsDic, options: []), let JSONText = String(data: JSONData, encoding: String.Encoding.utf8) {
                        JSONstring = JSONText
            }
        }
        let requestModel = InviteFriendsModel()
        requestModel.UserID = SingletonClass.SharedInstance.userData?.iD ?? ""
        requestModel.Phone = JSONstring

        FriendsWebserviceSubclass.inviteFriends(inviteFrinedsModel: requestModel){ (json, status, res) in
            
            self.refreshControl.endRefreshing()
            
            if status {
                self.tableData.removeAll()
                self.responseModel = InviteFriendsResponseModel(fromJson: json)
                
                // For displaying star image
                let friendCount = UserDefaults.standard.integer(forKey: UserDefaultKeys.kFriendRequestCount)
                if friendCount < self.responseModel?.friendRequest ?? 0 {
                    let parent = self.parent as? InviteViewController
                    if !(parent?.btnFriends.isSpringLoaded ?? false) {
                         parent?.imgStar.isHidden = false
                         parent?.imgStar.tintColor = .white
                    }
                } else {
                    let parent = self.parent as? InviteViewController
                    parent?.imgStar.isHidden = true
                }
                UserDefaults.standard.set(self.responseModel?.friendRequest, forKey: UserDefaultKeys.kFriendRequestCount)
                
                // For categories
                if let requestedArray = self.responseModel?.requests, requestedArray.count > 0 {
                    let arr = requestedArray.sorted(by: <)
                    let requestedDic = FriendsTableData(section: "Requested", rows: arr)
                    self.tableData.append(requestedDic)
                }
                if let registeredArray = self.responseModel?.registered, registeredArray.count > 0 {
                    self.registeredContacts = registeredArray.sorted(by: <)
                    let registeredDic = FriendsTableData(section: "Recommended", rows: self.registeredContacts)
                    self.tableData.append(registeredDic)
                }
                if let notRegisteredArray = self.responseModel?.notRegistered, notRegisteredArray.count > 0 {
                    let numbers = notRegisteredArray.compactMap({$0.phone})
                    let inviteArray = self.contactsArray.filter({numbers.contains($0.number)})
                    self.notRegisteredContacts = (inviteArray.unique(map: ({$0.name}))).sorted(by: <)
                    let notRegisteredDic = FriendsTableData(section: "Not Registered", rows: self.notRegisteredContacts)
                    self.tableData.append(notRegisteredDic)
                }
                self.tblFriends.reloadData()
                if self.tableData.count > 0  && !self.isSearchData {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                         let path = IndexPath.init(row: 0, section: 0)
                        self.tblFriends.scrollToRow(at: path, at: .top, animated: true)
                    }
                }
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
    func webserviceForAddFriends(id : String){
        
        let requestModel = FriendRequestModel()
        requestModel.SenderID = SingletonClass.SharedInstance.userData?.iD ?? ""
        requestModel.ReceiverID = id
        requestModel.type = "1" // For Contacts

        FriendsWebserviceSubclass.friendRequest(friendRequestModel: requestModel){ (json, status, res) in
            
            if status {
                self.retrieveContacts(from: self.store)
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
                UtilityClass.showAlert(Message: msg)
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
                self.retrieveContacts(from: self.store)
                let msg = (Localize.currentLanguage() == Languages.English.rawValue) ? json["message"].stringValue : json["arabic_message"].stringValue
                UtilityClass.showAlert(Message: msg)
            } else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}

