//
//  ImagesViewController.swift
//  Movecoins
//
//  Created by eww090 on 14/12/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit


class ImagesViewController: UIViewController, PagingScrollViewDelegate, PagingScrollViewDataSource {
    
     @IBOutlet weak var btnClose: UIButton!
    
    private let pagingControl:PagingScrollView = PagingScrollView()
    var imageArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagingControl.frame = self.view.bounds
        pagingControl.delegate   = self
        pagingControl.dataSource = self
        pagingControl.backgroundColor = UIColor.black
        self.view.addSubview(pagingControl)
        pagingControl.reloadData()
        self.view.bringSubviewToFront(btnClose)
    }
    
    func pagingScrollView(_ pagingScrollView: PagingScrollView, willChangedCurrentPage currentPageIndex:NSInteger) {
        print("current page will be changed to \(currentPageIndex).")
    }
    
    func pagingScrollView(_ pagingScrollView: PagingScrollView, didChangedCurrentPage currentPageIndex:NSInteger) {
        print("current page did changed to \(currentPageIndex).")
    }
    
    func pagingScrollView(_ pagingScrollView: PagingScrollView, layoutSubview view:UIView) {
        print("paging control call layoutsubviews.")
    }
    
    func pagingScrollView(_ pagingScrollView: PagingScrollView, recycledView view:UIView?, viewForIndex index:NSInteger) -> UIView {
        guard view == nil else { return view! }
        
        let zoomingView = ZoomingScrollView(frame: self.view.bounds)
        zoomingView.backgroundColor = UIColor.white
        zoomingView.singleTapEvent = {_ in }
        zoomingView.doubleTapEvent = {_ in }
        zoomingView.pinchTapEvent = {_ in }
        
        return zoomingView
    }
    
    func pagingScrollView(_ pagingScrollView: PagingScrollView, prepareShowPageView view:UIView, viewForIndex index:NSInteger) {
        guard let zoomingView = view as? ZoomingScrollView else { return }
        guard let zoomContentView = zoomingView.targetView as? ZoomContentView else { return }
    
//        let productsURL = NetworkEnvironment.baseGalleryURL + imageArray[index]
        if let url = URL(string: imageArray[index]) {
            zoomContentView.kf.indicatorType = .activity
            zoomContentView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))
        }
        
        // just call this methods after set image for resizing.
        zoomingView.prepareAfterCompleted()
        zoomingView.setMaxMinZoomScalesForCurrentBounds()
    }
    
    func startIndexOfPageWith(pagingScrollView: PagingScrollView) -> NSInteger {
        return 0
    }
    
    func numberOfPageWith(pagingScrollView: PagingScrollView) -> NSInteger {
        return imageArray.count
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
