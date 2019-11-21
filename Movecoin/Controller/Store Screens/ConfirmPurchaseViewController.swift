//
//  ConfirmPurchaseViewController.swift
//  Movecoin
//
//  Created by eww090 on 10/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class ConfirmPurchaseViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblAvailableBalance: UILabel!
    @IBOutlet weak var lblPurchase: UILabel!
    @IBOutlet var lblPrice: [UILabel]!
    @IBOutlet weak var viewCardSelect: UIView!
 
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationBarSetUp(isHidden: false, title: "", backroundColor: .clear, hidesBackButton: false)
        self.title =  "Confirm Purchase"
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setupFont(){
        for lbl in lblPrice {
            lbl.font = UIFont.semiBold(ofSize: 19)
        }
        switch UIDevice.current.screenType {
        case .iPhones_5_5s_5c_SE:
            lblProductName.font = UIFont.semiBold(ofSize: 20)
        default:
            lblProductName.font = UIFont.semiBold(ofSize: 24)
        }
        
        lblTotal.font = UIFont.semiBold(ofSize: 19)
        lblAddress.font = UIFont.semiBold(ofSize: 23)
        lblPurchase.font = UIFont.semiBold(ofSize: 19)
        lblAvailableBalance.font = UIFont.bold(ofSize: 18)
    }
    
    func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.cardViewTapped(_:)))
        viewCardSelect.addGestureRecognizer(tap)
        viewCardSelect.isUserInteractionEnabled = true
    }
    
    @objc func cardViewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        let controller = self.storyboard?.instantiateViewController(withIdentifier: CardListViewController.className) as! CardListViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // ----------------------------------------------------
    // MARK: - IBAction Methods
    // ----------------------------------------------------
    
    @IBAction func btnPurchaseTapped(_ sender: Any) {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyborad.instantiateViewController(withIdentifier: AlertViewController.className) as! AlertViewController
        destination.alertTitle = "Insufficient Balance"
        destination.alertDescription = "Your current balance is too low to purchase 50% off Mous - Protective phone cases. Don't want to wait? invite Friends and Family to earn faster!"
        
        destination.modalPresentationStyle = .overCurrentContext
        self.present(destination, animated: true, completion: nil)
//        add(destination, frame: self.view.frame)
    }
}
