//
//  PinMarker.swift
//  Movecoins
//
//  Created by eww090 on 27/12/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation
import MapKit
import Kingfisher

class PinMarker: NSObject, MKAnnotation {
    
    let id : String
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let image: String
    let tintColor : UIColor
    
    init(data : Nearbyuser) {
        
        let latitude = Double(data.latitude) ?? 0
        let longitude = Double(data.longitude) ?? 0
        self.title = data.fullName
        self.id = data.userID
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.image = data.profilePicture
        self.tintColor = ThemeBlueColor
        super.init()
    }
}

class PinMarkerView: MKMarkerAnnotationView {
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage()  }
        UIGraphicsEndImageContext()

        return newImage
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let pin = newValue as? PinMarker else { return }
            markerTintColor = pin.tintColor
            // self.glyphImage = #imageLiteral(resourceName: "Setting")
//            self.glyphImage = UIImage(named: "logo-select")
          
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
            imgView.contentMode = .scaleAspectFit
            imgView.kf.setImage(with: URL(string: pin.image), placeholder:  UIImage(named: "m-logo"), options: .none, progressBlock: nil) { (result) in
                switch result
                {
                case .success(let value):
                    print(value)
                    
                    DispatchQueue.global().async {
                        let img =  UIImage(named: "logo-select")
                        let asd = self.resizeImage(image: value.image, targetSize: CGSize(width: 34, height: 34))
                        
                        DispatchQueue.main.async {
                           
                            self.glyphImage = img //self.resizeImage(image: value.image, targetSize: CGSize(width: 10, height: 10))
                            
                        }
                    }
                    
                    
                case .failure(let error):
                    print("The error for image is \(error.localizedDescription)")
                }
            }
        }
    }
}
