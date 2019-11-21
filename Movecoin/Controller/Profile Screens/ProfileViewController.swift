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
    // MARK: - IBOutlets
    // ----------------------------------------------------

    @IBOutlet weak var segmentedControl: TTSegmentedControl!
    @IBOutlet weak var btnMyFriends: UIButton!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    
    @IBOutlet var lblTitle: [UILabel]!
    @IBOutlet weak var lblMemberSince: UILabel!
    @IBOutlet weak var lblTotalMoveCoins: UILabel!
    @IBOutlet weak var lblTotalSteps: UILabel!
    @IBOutlet weak var lblAverage: UILabel!
    @IBOutlet weak var lblAverageSteps: UILabel!
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
        setupSegmentedControl()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationBarSetUp(hidesBackButton: true)
        setUpNavigationItems()
        setupProfileData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.parent?.navigationItem.titleView = nil
        self.parent?.navigationItem.leftBarButtonItems?.removeAll()
        self.parent?.navigationItem.rightBarButtonItems?.removeAll()
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
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
            imgProfilePicture.kf.setImage(
                with: url,
                placeholder: UIImage(named: "user"),
                options: [
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc func btnChatTapped(){
        let destination = self.storyboard?.instantiateViewController(withIdentifier: ChatListViewController.className) as! ChatListViewController
        self.parent?.navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc func btnSettingTapped(){
        let destination = self.storyboard?.instantiateViewController(withIdentifier: SettingsViewController.className) as! SettingsViewController
        self.parent?.navigationController?.pushViewController(destination, animated: true)
    }
}
