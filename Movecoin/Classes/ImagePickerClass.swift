//
//  ImagePicker.swift
//  FairWay
//
//  Created by Mayur iMac on 16/08/19.
//  Copyright © 2019 EWW077. All rights reserved.
//

import Foundation
import AVFoundation
import Photos


public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?, SelectedTag:Int)
}

open class ImagePickerClass: NSObject {

    private lazy var pickerController = UIImagePickerController()
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    private var SelectedTag:Int = 0
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate, allowsEditing : Bool) {
//        self.pickerController = UIImagePickerController()

        super.init()
        self.pickerController.navigationController?.isNavigationBarHidden = false
        self.presentationController = presentationController
        self.delegate = delegate
       
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = allowsEditing

        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String, tag : Int) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            if type == .camera {
                self.checkCamera()
            } else {
                self.pickerController.sourceType = type
                self.pickerController.modalPresentationStyle = .overCurrentContext
                self.presentationController?.present(self.pickerController, animated: true)
            }
        }
    }

    public func present(from sourceView: UIView) {
        self.SelectedTag = sourceView.tag
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo".localized, tag: self.SelectedTag) {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll".localized, tag: self.SelectedTag) {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library".localized, tag: self.SelectedTag) {
            alertController.addAction(action)
        }
        if let sourceImage = (sourceView as! UIImageView).image {
            if let defaultImage = UIImage(named: "m-logo") {
                let isDefaultImage = sourceImage.isEqualToImage(defaultImage)
                if (!isDefaultImage) {
                    alertController.addAction(UIAlertAction(title: "Remove Photo".localized, style: .destructive, handler: { (action) in
                        self.delegate?.didSelect(image: nil, SelectedTag:101)
                    }))
                }
            }
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        alertController.modalPresentationStyle = .overCurrentContext
        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        self.delegate?.didSelect(image: image, SelectedTag: self.SelectedTag)
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ImagePickerClass: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[.originalImage] as! UIImage
        self.pickerController(picker, didSelect: chosenImage)
    }
}

extension UIImage {

    func isEqualToImage(_ image: UIImage) -> Bool {
        return self.pngData() == image.pngData()
    }
}

extension ImagePickerClass {
    
    func callCamera(){
        self.pickerController.sourceType = .camera
        self.pickerController.modalPresentationStyle = .overCurrentContext
        self.presentationController?.present(self.pickerController, animated: true)
    }
    func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: callCamera() // Do your stuff here i.e. callCameraMethod()
        case .denied: alertToEncourageCameraAccessInitially()
        case .notDetermined: alertToEncourageCameraAccessInitially()
        default: alertToEncourageCameraAccessInitially()
        }
    }

    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: "IMPORTANT".localized,
            message: "Camera access required for capturing photos!".localized,
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera".localized, style: .cancel, handler: { (alert) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }))
        self.presentationController?.present(alert, animated: true)
    }
}
