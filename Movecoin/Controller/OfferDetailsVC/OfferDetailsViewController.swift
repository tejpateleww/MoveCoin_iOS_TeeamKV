//
//  OfferDetailsViewController.swift
//  Movecoins
//
//  Created by Rahul Patel on 08/09/21.
//  Copyright © 2021 eww090. All rights reserved.
//

import UIKit

class OfferDetailsViewController: UIViewController {

    @IBOutlet var imgProduct: UIImageView?
    @IBOutlet var lblClaimNowTitle: LocalizLabel?
    @IBOutlet var lblClaimDetails: UILabel?
    @IBOutlet var lblOfferDetailsTitle: UILabel?
    @IBOutlet var lblOfferDetails: UILabel?
    @IBOutlet var btnCouponTitle: ThemeButton?
    @IBOutlet var btnCouponCopy: UIButton?
    @IBOutlet var txtViewLink: UITextView?
    @IBOutlet var lblTitleGoToStore: UILabel?
    @IBOutlet var lblTitleOfProduct: UILabel?
    @IBOutlet var btnContinueTitle: UIButton?
    @IBOutlet var viewOfferDetail: UIView?
    @IBOutlet var stackViewOfferDetail: UIStackView?
    @IBOutlet var viewClaimDetails: UIView?
    @IBOutlet var stackViewClaimDetails: UIStackView?
    @IBOutlet var scrollview: UIScrollView?

    var walletDetail : WalletData!
    var offerDetail : OfferDetailsModel!
    var imgArray : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollview?.isHidden = true
        self.webserviceForOfferDetails(productId: walletDetail.offerID ?? "0", id: walletDetail.iD ?? "0")
        setText()
        self.setupFont()

        self.title = "title_bought_product".localized
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.lblClaimNowTitle?.textAlignment = .left
//        self.lblOfferDetailsTitle?.textAlignment = .left
//        self.lblTitleOfProduct?.textAlignment = .left
        self.lblOfferDetails?.isHidden = true
        self.lblClaimDetails?.isHidden = true

    }
   fileprivate func setText()
    {
        self.lblOfferDetailsTitle?.text = "message_offer_details".localized
        self.btnCouponCopy?.setTitle("title_copy_code".localized, for: .normal)
        self.lblTitleGoToStore?.text = "message_go_to_store".localized
        self.btnContinueTitle?.setTitle("title_Continue".localized, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.statusBarSetUp(backColor: .clear)
        self.lblOfferDetails?.isHidden = false
        self.lblClaimDetails?.isHidden = false
        self.navigationBarSetUp(title: "title_bought_product".localized, backroundColor: .clear, hidesBackButton: false)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.statusBarSetUp(backColor: .clear)

    }
    
    @IBAction func btnCoupon(_ sender: Any) {
        UIPasteboard.general.string = btnCouponTitle?.titleLabel?.text
        UIView.transition(with: self.btnCouponTitle!, duration: 1.0, options: [.curveEaseInOut, .transitionFlipFromBottom], animations: {
            self.btnCouponTitle?.setTitle("title_copied".localized, for: .normal)
        }, completion: {_ in
            UIView.transition(with: self.btnCouponTitle!, duration: 1.0, options: [.curveEaseInOut, .transitionFlipFromBottom], animations: {
                self.btnCouponTitle?.setTitle(self.offerDetail.offerDetails.couponCode, for: .normal)
            }, completion: nil)
        })
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        UIApplication.shared.open((URL(string:offerDetail.offerDetails.link) ?? URL(fileURLWithPath: "")) as URL)
    }
    
    
    func setupFont(){
        lblClaimNowTitle?.font = UIFont.regular(ofSize: 25)
        lblClaimDetails?.font = UIFont.regular(ofSize: 18)
        lblOfferDetailsTitle?.font = UIFont.regular(ofSize: 22)
        lblOfferDetails?.font = UIFont.regular(ofSize: 18)
        btnCouponTitle?.titleLabel?.font = UIFont.light(ofSize: 26)
        btnCouponCopy?.titleLabel?.font = UIFont.regular(ofSize: 18)
        txtViewLink?.font = UIFont.regular(ofSize: 18)
        lblTitleGoToStore?.font = UIFont.regular(ofSize: 18)
        btnContinueTitle?.titleLabel?.font = UIFont.regular(ofSize: 18)
        lblTitleOfProduct?.font = UIFont.regular(ofSize: 18)

    }
    
    func setupOfferData(){
        // For Images
        
//        if let url = URL(string: (NetworkEnvironment.baseImageURL + offerDetail.offerDetails.image) ) {
//            imgProduct?.kf.indicatorType = .activity
//            imgProduct?.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))
//        }
//        if(offerDetail.offerDetails.offerType == "offer_link")
//        {
//            self.btnCouponCopy?.isHidden = true
//            self.btnCouponTitle?.isHidden = true
//        }
        lblOfferDetails?.text = offerDetail.offerDetails.offerDetails
        lblOfferDetails?.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        
        lblClaimDetails?.text = offerDetail.offerDetails.howToClaim
        lblClaimDetails?.textAlignment = (Localize.currentLanguage() == Languages.Arabic.rawValue) ? .right : .left
        
        // For the textview proper width and height according to content
        lblTitleOfProduct?.text = offerDetail.offerDetails.name
        
        self.txtViewLink?.text = offerDetail.offerDetails.link
        
        self.btnCouponTitle?.setTitle(offerDetail.offerDetails.couponCode, for: .normal)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension OfferDetailsViewController {
    
    func webserviceForOfferDetails(productId : String = "", id : String = ""){
        
        UtilityClass.showHUD()
        
        let productsURL = NetworkEnvironment.baseURL + ApiKey.offerDetails.rawValue + "/" + productId + "/" + id
        OffersWebserviceSubclass.getOfferDetails(strURL: productsURL){ (json, status, res) in
            if status {
                self.offerDetail = OfferDetailsModel(fromJson: json)
                self.setupOfferData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.scrollview?.isHidden = false
                    UtilityClass.hideHUD()
                }
            } else {
                UtilityClass.hideHUD()
                UtilityClass.showAlertOfAPIResponse(param: res)
            }
        }
    }
    
}
