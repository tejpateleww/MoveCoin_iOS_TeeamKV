//
//  InviteFriendsViewController.swift
//  Movecoin
//
//  Created by eww090 on 11/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import Lottie
import FirebaseAnalytics
class InviteFriendsViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintMiddle: NSLayoutConstraint!
    
    @IBOutlet weak var btnClaimNow: ThemeButton!{
        didSet{
            btnClaimNow.titleLabel?.font =  FontBook.SemiBold.of(size: 18)
            btnClaimNow.cornerRadius = btnClaimNow.frame.height / 2
            btnClaimNow.setTitle("Claim Now".localized, for: .normal)
        }
    }
    @IBOutlet weak var viewOfferBG: UIView!{ didSet{ viewOfferBG.layer.cornerRadius = 10}}
    @IBOutlet var viewParent: UIView!
    @IBOutlet weak var lblTitle: LocalizLabel!
    @IBOutlet weak var lblDescription: LocalizLabel!
    @IBOutlet weak var lblCode: LocalizLabel!
    @IBOutlet weak var lblReferral: UILabel!
    @IBOutlet weak var viewReferralCode: TransparentView!
    @IBOutlet weak var viewBoxAnimation: UIView!
    
    
    var isHideBottomPart : Bool = true
    {
        didSet
        {
            
            self.viewOfferBG.isHidden = isHideBottomPart
            self.btnClaimNow.isHidden = isHideBottomPart
            
            self.constraintBottom.priority = UILayoutPriority(isHideBottomPart ? 850 : 700)
            self.constraintMiddle.priority = UILayoutPriority(isHideBottomPart ? 850 : 700)
            
        }
    }
    
    
    var redeemData : RedeemInfo!
    
    @IBOutlet weak var lblTermsConditions: LocalizLabel!{
        didSet{
            lblTermsConditions.font = FontBook.Regular.of(size: 07)
            lblTermsConditions.text = "Terms and Conditions:"
        }
    }
    
    @IBOutlet weak var lblMaximum100: LocalizLabel!{
        didSet{
            lblMaximum100.font = FontBook.Regular.of(size: 09)
            lblMaximum100.text = "*Purchase one product at least."
        }
    }
    
    @IBOutlet weak var lblMaximum1000: LocalizLabel!{
        didSet{
            lblMaximum1000.font = FontBook.Regular.of(size: 09)
            lblMaximum1000.text = "*User who received invitation must walk 5000 steps."
        }
    }
    
    @IBOutlet weak var lblOfferInfo: LocalizLabel!{
        didSet{
            lblOfferInfo.font = FontBook.Regular.of(size: 16)
            lblOfferInfo.text = "LIMITED TIME OFFER"
        }
    }
    @IBOutlet weak var lblWinningInfo: LocalizLabel!
    {
        didSet{
            lblWinningInfo.font = FontBook.Regular.of(size: 16)
            lblWinningInfo.text = "Win 1 SAR for 1 Invitation"
        }
    }
    @IBOutlet weak var lblInvitationInfo: LocalizLabel!
    {
        didSet{
            lblInvitationInfo.font = FontBook.Regular.of(size: 15)
        }
    }
    @IBOutlet weak var lblInvitationCount: LocalizLabel!
    {
        didSet{
            lblInvitationCount.font = FontBook.Regular.of(size: 16)
            //            lblInvitationCount.text = "100 Invites or More"
        }
    }
    @IBOutlet weak var lblMaxUsers: LocalizLabel!
    {
        didSet{
            lblMaxUsers.font = FontBook.Regular.of(size: 09)
            lblMaxUsers.text = "*You can claim when you reach 100 invitations once during the offer period."
        }
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var animationView = AnimationView(name: "happy-birthday")
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
        isHideBottomPart = true
        
        
        lblReferral.text = SingletonClass.SharedInstance.userData?.referralCode ?? ""
        self.webserviceCallForGettingClaimInfo()
        //        self.animate()
        //        lblInvitationCount.attributedText = attributedJoined(regular1: "", bold: "100", regular2: " Invites More" , font_reg: FontBook.Bold.of(size: 16) , font_bold: FontBook.Bold.of(size: 18), isboldBlue: true)
        //        lblInvitationCount.text = "100 Invites More"
        //        let combination = NSMutableAttributedString()
        //        let fisrt  = attributedJoined(regular1: "Win ", bold: "1 SAR", regular2: "" , font_reg: FontBook.Regular.of(size: 16) , font_bold: FontBook.Bold.of(size: 18), isboldBlue: true)
        //        let second  = attributedJoined(regular1: " for ", bold: "1", regular2: " Invitation" , font_reg: FontBook.Regular.of(size: 16) , font_bold: FontBook.Bold.of(size: 18), isboldBlue: true)
        //        combination.append(fisrt)
        //        combination.append(second)
        //        lblWinningInfo.attributedText = combination
        //        lblInvitationInfo.attributedText = attributedJoined(regular1: "You have invited ", bold: "105", regular2: "", font_reg: FontBook.Regular.of(size: 14) , font_bold: FontBook.Bold.of(size: 16), isboldBlue: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        Analytics.logEvent("InviteFriendsScreen", parameters: nil)
        //        self.animate()
    }
    
    
    func attributedJoined(regular1 : String , bold : String, regular2 : String , font_reg : UIFont , font_bold : UIFont , isboldBlue:Bool) -> NSMutableAttributedString {
        
        let colorBlue = UIColor(red: 40/255, green: 165/255, blue: 198/255, alpha: 1.0)
        let colorblue = isboldBlue ? colorBlue : .white
        let Str_reg1 = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:font_reg]
        let Str_bold = [NSAttributedString.Key.foregroundColor:colorblue, NSAttributedString.Key.font: font_bold]
        let Str_reg2 = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:font_reg]
        
        let partOne = NSMutableAttributedString(string: regular1, attributes: Str_reg1)
        let partTwo = NSMutableAttributedString(string: bold, attributes: Str_bold)
        let partthree  = NSMutableAttributedString(string: regular2, attributes: Str_reg2)
        let combination = NSMutableAttributedString()
        //        let paragraphStyle = NSMutableParagraphStyle()
        //        paragraphStyle.lineSpacing = 0.5
        //        combination.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, combination.length))
        
        combination.append(partOne)
        combination.append(partTwo)
        combination.append(partthree)
        
        return combination
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
        self.animate()
        //        self.view.layoutIfNeeded()
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setupFont(){
        lblTitle.font = UIFont.semiBold(ofSize: 25)
        lblDescription.font = UIFont.regular(ofSize: 15)
        lblCode.font = UIFont.regular(ofSize: 20)
        lblReferral.font = UIFont.semiBold(ofSize: 18)
    }
    
    func animate() {
        print("Animate")
        animationView.frame = CGRect(x: 0, y: 0, width: viewBoxAnimation.frame.width, height: viewBoxAnimation.frame.height)
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 0.5
        if !viewBoxAnimation.subviews.contains(animationView){
            viewBoxAnimation.addSubview(animationView)
        }
        
        animationView.play()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    var vc : UIActivityViewController?
    
    @IBAction func btnClaimNowTapped(_ sender: Any) {
        
        //        webserviceCallForGettingClaimInfo()
        
        //        self.moveToBankDetailScreen()
        //        return
        //
        if(Double(self.redeemData.inviteeCount) ?? 0 < 2)
        {
            UtilityClass.showAlertWithCompletion(title: "MoveCoins rewards".localized, Message: "Invitations numbers not enough to claim".localized, ButtonTitle: "OK".localized) {
                
            }
        }
        else
        {
            
            UtilityClass.showAlertWithTwoButtonCompletion(title: "MoveCoins rewards".localized, Message: "You have won".localized + " " + self.redeemData.inviteeCount + " " + "SAR".localized, ButtonTitle1: "Confirm".localized, ButtonTitle2: "Cancel".localized) { index in
                if index == 0{
                    self.moveToBankDetailScreen()
                }
            }
        }
    }
    
    func moveToBankDetailScreen()
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let bankDetailsScreen = mainStoryboard.instantiateViewController(withIdentifier: BankDetailsViewController.className) as! BankDetailsViewController
        bankDetailsScreen.strClaimedSAR = self.redeemData.inviteeCount
        self.navigationController?.pushViewController(bankDetailsScreen, animated: true)
        
    }
    
    
    @IBAction func btnInviteFriendsTapped(_ sender: Any) {
        
        var text = "Check out this app ".localized + kAppName.localized + ", referral code - ".localized + "(\((lblReferral.text ?? "")))" + "\n" + appURL
     
        if(Localize.currentLanguage() == Languages.Arabic.rawValue)
        {
            
            let text1 = "referral code - ".localized
            let text2 = "Check out this app ".localized
            let text3 = kAppName.localized
            let text4 = "\n"
            let text5 = "(\(lblReferral.text ?? ""))"
            text = text1 + text2 + text3 + text4 + text5 + text4 + appURL
            
            print(text)
        }
        vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        present(vc!, animated: true)
    }
    
    
    func webserviceCallForGettingClaimInfo()
    {
        let profileData = ProfileData()
        guard let id = SingletonClass.SharedInstance.userData?.iD else {
            return
        }
        profileData.user_id = id
        UserWebserviceSubclass.rewardClaimInfo(profileDataModel: profileData) { (json, status, res) in
            if status {
                let responseModel = RedeemInfo(fromJson: json)
                self.redeemData = responseModel
                self.isHideBottomPart = !self.redeemData.offerActive
                self.lblInvitationInfo.text = "You have invited".localized + " " + self.redeemData.inviteeCount + "*"
            }
            else {
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
}
