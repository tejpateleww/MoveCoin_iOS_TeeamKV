//
//  ChatViewController.swift
//  ChatDemo
//
//  Created by Apple on 30/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


class ChatViewController: UIViewController ,UINavigationControllerDelegate {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------

    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    
    @IBOutlet weak var conVwMessageBottom: NSLayoutConstraint!

    @IBOutlet weak var btnSend: UIButton!
    
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var arrData = [MessageData]()
    var receiverID : String?
    lazy var profileImg = UIImageView(image: UIImage(named: "m-logo"))
//    var userData : [String : String]!

    // ----------------------------------------------------
    // MARK: - --------- Life-Cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        webserviceForChatHistory(isLoading: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboard(false)
        self.hideKeyboard()
        self.registerForKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpNavigationItems()
        
        if arrData.count>0 {
            tblVw.reloadData()
            let indexPath = IndexPath.init(row: arrData.count-1, section: 0)
            tblVw.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupKeyboard(true)
        self.deregisterFromKeyboardNotifications()
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.view.frame.size.height))
        txtMessage.leftView = paddingView
        txtMessage.leftViewMode = .always
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setupFont(){
        txtMessage.font = UIFont.regular(ofSize: 15)
    }
    
    func setUpNavigationItems(){
        
        let profileView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        
        let imgview = UIImageView(frame: profileView.frame)
        imgview.image = UIImage(named: "photo-frame")
        imgview.contentMode = .scaleAspectFit
        
        profileImg.frame = CGRect(x: 5, y: 5, width: 34, height: 34)
        profileImg.contentMode = .scaleAspectFill
        profileImg.cornerRadius = 17
        profileImg.clipsToBounds = true
        
        profileView.addSubview(imgview)
        profileView.addSubview(profileImg)
        let item = UIBarButtonItem(customView: profileView)
        self.navigationItem.setRightBarButton(item, animated: true)
    }
    
    func scrollToBottom() {
        let path = IndexPath.init(row: arrData.count-1, section: 0)
        tblVw.scrollToRow(at: path, at: .bottom, animated: true)
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        if #available(iOS 11.0, *) {
            conVwMessageBottom.constant = keyboardSize!.height - view.safeAreaInsets.bottom
        } else {
            conVwMessageBottom.constant = keyboardSize!.height
        }
        self.view.animateConstraintWithDuration()
        if arrData.count > 0 {
           scrollToBottom()
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        conVwMessageBottom.constant = 0
        self.view.animateConstraintWithDuration()
        
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func resetAll() {
        txtMessage.text = ""
        self.view.animateConstraintWithDuration()
    }
    
    
    // ----------------------------------------------------
    //MARK:- --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func sendClick(_ sender: UIButton) {
        txtMessage.text = txtMessage.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if !txtMessage.text!.isEmpty {
            self.btnSend.isUserInteractionEnabled = false
            self.sendMessage(message: txtMessage.text!)
        }
    }
    
    @IBAction func profileClick(_ sender: Any) {
        self.performSegue(withIdentifier: "segueProfileDetail", sender: nil)
    }
}

// ----------------------------------------------------
//MARK:- --------- Tableview Methods ---------
// ----------------------------------------------------

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: MessageCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let obj = arrData[indexPath.row]
        let strIdentifier = obj.senderID == SingletonClass.SharedInstance.userData?.iD ? "SenderCell" : "RecieverCell"
    
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifier, for: indexPath) as! MessageCell
        cell.lblMessage.text = obj.message
        cell.lblMessage.isHidden = obj.message.isEmpty ? true : false
        if let chatDate = UtilityClass.changeDateFormateFrom(dateString: obj.date, fromFormat: DateFomateKeys.api, withFormat: DateFomateKeys.displayDateTime) {
             cell.lblTime.text = chatDate
        }
        cell.lblReadStatus.isHidden = true
        cell.lblMessage.textColor = UIColor.white
        cell.lblTime.textColor = UIColor.white
        cell.lblReadStatus.textColor = UIColor.white
        
        if obj.senderID == SingletonClass.SharedInstance.userData?.iD {
            cell.vwChatBg.backgroundColor = TransparentColor
            cell.lblMessage.textColor = UIColor.white
            cell.lblTime.textColor = UIColor.white
            cell.lblReadStatus.textColor = UIColor.white
        }
        cell.selectionStyle = .none
        return cell
    }
}

// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension ChatViewController {
    
    func sendMessage(message:String){
        
        let requestModel = SendMessage()
        requestModel.SenderID = SingletonClass.SharedInstance.userData?.iD ?? ""
        requestModel.ReceiverID = receiverID ?? ""
        requestModel.Message = message
        
        FriendsWebserviceSubclass.sendMessage(sendMessageModel: requestModel){ (json, status, res) in
            
            self.btnSend.isUserInteractionEnabled = true
            if status {
                let dataJson = json["data"]
                if !dataJson.isEmpty{
                    let obj = MessageData(fromJson: dataJson)
                    self.arrData.append(obj)
                }
                if self.arrData.count > 0 {
                    let indexPath = IndexPath.init(row: self.arrData.count - 1, section: 0)
                    self.tblVw.insertRows(at: [indexPath], with: .bottom)
                    self.scrollToBottom()
                    self.resetAll()
                }
            }
        }
    }
    
    func webserviceForChatHistory(isLoading : Bool){
        if isLoading {
            UtilityClass.showHUD()
        }
        
        let requestModel = ChatHistoryModel()
        requestModel.sender_id = SingletonClass.SharedInstance.userData?.iD ?? ""
        requestModel.receiver_id = receiverID ?? ""
        
        FriendsWebserviceSubclass.chatHistory(chatHistoryModel: requestModel){ (json, status, res) in
            
            UtilityClass.hideHUD()
            if status {
                let responseModel = ChatHistoryResponseModel(fromJson: json)
               
                self.navigationBarSetUp(title: responseModel.receiverArr.fullName ?? "")
                self.profileImg.kf.setImage(with: URL(string: responseModel.receiverArr.profilePicture ?? ""), placeholder:  UIImage(named: "m-logo"), options: .none, progressBlock: nil) { (result) in
                           
                       }
                if responseModel.chatHistory.count > 0  {
                    self.arrData = responseModel.chatHistory
                    self.tblVw.reloadData()
                    self.scrollToBottom()
                }
            }
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- Cell and Structure Methods ---------
// ----------------------------------------------------

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblReadStatus: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var vwChatBg: UIView!
    @IBOutlet weak var imgVwPhoto: UIImageView!
    @IBOutlet weak var con_ImgHeight: NSLayoutConstraint!
    @IBOutlet weak var con_vwEmergencyHeight: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lblTime.font = UIFont.light(ofSize: 10)
        lblReadStatus.font = UIFont.light(ofSize: 10)
        lblMessage.font = UIFont.regular(ofSize: 15)
    }
}

struct MessageObject  {
    var strMessage: String = ""
    var isSender: Bool = false
    var isEmergency: Bool = false
    var isImage: Bool = false
    var imgMessage = UIImage()
    
    var id : String?
    var bookingId : String?
    var type : String?
    var senderId : String?
    var sender : String?
    var receiverId : String?
    var receiver : String?
    var message : String?
    var date : String?
}

// ----------------------------------------------------
//MARK:- --------- UIView extention ---------
// ----------------------------------------------------

extension UIView {
    //For layout change animation
    func animateConstraintWithDuration(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.layoutIfNeeded() ?? ()
        })
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

func setupKeyboard(_ enable: Bool) {
    //    IQKeyboardManager.sharedManager().enable = enable
    //    IQKeyboardManager.sharedManager().enableAutoToolbar = enable
    //    IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = !enable
    
    //    IQKeyboardManager.sharedManager().previousNextDisplayMode = .alwaysShow
}

// ----------------------------------------------------
//MARK:- --------- UIViewcontroller extention ---------
// ----------------------------------------------------

extension UIViewController {
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
