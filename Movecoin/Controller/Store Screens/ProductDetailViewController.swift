//
//  ProductDetailViewController.swift
//  Movecoin
//
//  Created by eww090 on 13/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewBottom: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblStore: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblBuy: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    var thisWidth:CGFloat = 0
    let imgArray = ["airpods.jpg","airpods1.jpg","airpods2.jpg"]
    var viewType : PurchaseDetailViewType = .Purchase
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetUp()
        self.setUpView()
        self.setupFont()
    }
    
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setUpView(){
        thisWidth = windowWidth
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pageControl.hidesForSinglePage = true
        
        switch viewType {
        case .History:
            viewBottom.isHidden = true
            break
            
        default:
            break
        }
    }
    
    func setupFont(){
        lblBuy.font = UIFont.semiBold(ofSize: 19)
        lblPrice.font = UIFont.semiBold(ofSize: 19)
        lblTitle.font = UIFont.bold(ofSize: 26)
        lblDescription.font = UIFont.bold(ofSize: 16)
        lblStore.font = UIFont.regular(ofSize: 14)
    }
    
    // ----------------------------------------------------
    // MARK: - IBAction Methods
    // ----------------------------------------------------
    
    @IBAction func btnPurchaseTapped(_ sender: Any) {
//        let storyborad = UIStoryboard(name: "Main", bundle: nil)
//        let destination = storyborad.instantiateViewController(withIdentifier: AlertViewController.className) as! AlertViewController
//        destination.alertTitle = "Insufficient Balance"
//        destination.alertDescription = "Your current balance is too low to purchase 50% off Mous - Protective phone cases. Don't want to wait? invite Friends and Family to earn faster!"
//        add(destination, frame: self.view.frame)
    }
}

extension ProductDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailCollectionViewCell.className, for: indexPath) as! ProductDetailCollectionViewCell
        cell.imgProduct.image = UIImage(named: imgArray[indexPath.section])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        thisWidth = windowWidth
        return CGSize(width: thisWidth, height: collectionView.frame.height)
    }
    
    
}
