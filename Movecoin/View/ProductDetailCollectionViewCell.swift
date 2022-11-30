//
//  ProductDetailCollectionViewCell.swift
//  Movecoin
//
//  Created by eww090 on 10/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class ProductDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgProduct: UIImageView!

    var productImage: String? {
        didSet{
            if let data = productImage {
                // For Image
//                let productsURL = NetworkEnvironment.baseGalleryURL + data
                if let url = URL(string: data) {
                    self.imgProduct.kf.indicatorType = .activity
                    self.imgProduct.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))
                    self.imgProduct.contentMode = .scaleAspectFill
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
//        self.imgProduct.isUserInteractionEnabled = true
//        self.imgProduct.addGestureRecognizer(pinch)
        
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        
        if let view = sender.view {
            switch sender.state {
                case .changed:
                    let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                                 y: sender.location(in: view).y - view.bounds.midY)
                    let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                           .scaledBy(x: sender.scale, y: sender.scale)
                           .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
                    view.transform = transform
                    sender.scale = 1
                case .ended:
                    UIView.animate(withDuration: 0.2, animations: {
                           view.transform = CGAffineTransform.identity
                    })
                default:
                    return
            }
        }
    }
    
}
