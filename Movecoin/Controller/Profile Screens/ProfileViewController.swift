//
//  ProfileViewController.swift
//  Movecoin
//
//  Created by eww090 on 16/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import TTSegmentedControl
import Kingfisher

class ProfileViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------

    @IBOutlet weak var segmentedControl: TTSegmentedControl!
    @IBOutlet weak var btnMyFriends: UIButton!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var viewProfile: UIView!
    
    @IBOutlet var lblTitle: [UILabel]!
    @IBOutlet weak var lblMemberSince: UILabel!
    @IBOutlet weak var lblTotalMoveCoins: UILabel!
    @IBOutlet weak var lblTotalSteps: UILabel!
    @IBOutlet weak var lblAverage: UILabel!
    @IBOutlet weak var lblAverageSteps: UILabel!
    
    
    // ----------------------------------------------------
    //MARK:- --------- Variables ---------
    // ----------------------------------------------------
    
    private var imagePicker : ImagePickerClass!
    var selectedImage : UIImage?
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
        self.setupView()
        setupSegmentedControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationBarSetUp(hidesBackButton: true)
       
        setupProfileData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
         setUpNavigationItems()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.parent?.navigationItem.titleView = nil
        self.parent?.navigationItem.leftBarButtonItems?.removeAll()
        self.parent?.navigationItem.rightBarButtonItems?.removeAll()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setupSegmentedControl(){
        segmentedControl.allowChangeThumbWidth = false
        segmentedControl.itemTitles = ["Weekly","Monthly","Yearly"]
        segmentedControl.selectedTextFont = FontBook.Bold.of(size: 16)
        segmentedControl.defaultTextFont =  FontBook.Bold.of(size: 16)
        segmentedControl.layer.cornerRadius = 20
    }
    
    func setupFont(){
        for lbl in lblTitle {
            lbl.font = UIFont.bold(ofSize: 13)
        }
        btnMyFriends.titleLabel?.font = UIFont.bold(ofSize: 18)
        lblTotalSteps.font = UIFont.bold(ofSize: 13)
        lblAverageSteps.font = UIFont.bold(ofSize: 13)
        lblTotalMoveCoins.font = UIFont.bold(ofSize: 13)
        lblAverage.font = UIFont.semiBold(ofSize: 13)
        lblMemberSince.font = UIFont.regular(ofSize: 12)
    }
    
    func setupView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.profileViewTapped(_:)))
        viewProfile.addGestureRecognizer(tap)
        viewProfile.isUserInteractionEnabled = true
        self.imagePicker = ImagePickerClass(presentationController: self, delegate: self, allowsEditing: false)
    }
    
    func setUpNavigationItems(){
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "chat"), style: .plain, target: self, action: #selector(btnChatTapped))
        self.parent?.navigationItem.leftBarButtonItems = [leftBarButton]
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(btnSettingTapped))
        self.parent?.navigationItem.rightBarButtonItems = [rightBarButton]
        
        // Multiline Title
        
        let upperTitle = NSMutableAttributedString(string: SingletonClass.SharedInstance.userData?.nickName ?? "", attributes: [NSAttributedString.Key.font: FontBook.Bold.of(size: 22.0), NSAttributedString.Key.foregroundColor: UIColor.white])
//        let lowerTitle = NSMutableAttributedString(string: "\nMember since Augest 5,2019", attributes: [NSAttributedString.Key.font: FontBook.Regular.of(size: 12.0) , NSAttributedString.Key.foregroundColor: UIColor.white])
//        upperTitle.append(lowerTitle)
        
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height:50))
        label1.numberOfLines = 0
        label1.textAlignment = .center
        label1.attributedText = upperTitle  //assign it to attributedText instead of text
        self.parent?.navigationItem.titleView = label1
    }
    
    func setupProfileData(){
        if let since = UtilityClass.changeDateFormateFrom(dateString: SingletonClass.SharedInstance.userData?.createdDate ?? "", fromFormat: "", withFormat: "MMM dd, yyyy") {
            lblMemberSince.text = "Member since \(since)"
        }
        if let url = URL(string: SingletonClass.SharedInstance.userData?.profilePicture ?? "") {
            imgProfilePicture.kf.indicatorType = .activity
            imgProfilePicture.kf.setImage(with: url, placeholder: UIImage(named: "m-logo"))
        }
        btnMyFriends.setTitle("My Friends (\(SingletonClass.SharedInstance.userData?.friends ?? "0"))", for: .normal)
    }
    
    @objc func btnChatTapped(){
        let destination = self.storyboard?.instantiateViewController(withIdentifier: ChatListViewController.className) as! ChatListViewController
        self.parent?.navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc func btnSettingTapped(){
        let destination = self.storyboard?.instantiateViewController(withIdentifier: SettingsViewController.className) as! SettingsViewController
        self.parent?.navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc func profileViewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        self.imagePicker.present(from: imgProfilePicture)
    }
}

// ----------------------------------------------------
//MARK:- --------- ImagePicker Delegate Methods ---------
// ----------------------------------------------------

extension ProfileViewController :  ImagePickerDelegate {
    
    func didSelect(image: UIImage?, SelectedTag: Int) {
        
        if(image == nil && SelectedTag == 101){
            self.imgProfilePicture.image = UIImage(named: "m-logo")//UIImage.init(named: "imgPetPlaceholder")
        }else if image != nil{
            self.imgProfilePicture.image = image
        }else{
            return
        }
        self.selectedImage = self.imgProfilePicture.image
        webserviceCallForEditProfile()
    }
}

// ----------------------------------------------------
// MARK: - --------- Webservice Methods ---------
// ----------------------------------------------------

extension ProfileViewController {
    
    func webserviceCallForEditProfile(){
        
        UtilityClass.showHUD()
        let editModel = EditProfileModel()
        editModel.UserID = SingletonClass.SharedInstance.userData?.iD ?? ""

        UserWebserviceSubclass.editProfile(editProfileModel: editModel, image: selectedImage){ (json, status, res) in
            
            UtilityClass.hideHUD()
            
            if status{
                 let loginResponseModel = LoginResponseModel(fromJson: json)
                do{
                    try UserDefaults.standard.set(object: loginResponseModel.data, forKey: UserDefaultKeys.kUserProfile)
                }catch{
                    UtilityClass.showAlert(Message: error.localizedDescription)
                }
                self.getUserData()
                UtilityClass.showAlert(Message: json["message"].stringValue)
            }
            else{
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
