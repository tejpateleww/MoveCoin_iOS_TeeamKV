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


public protocol ImagePickerDelegate: class {
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

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.pickerController.modalPresentationStyle = .overCurrentContext
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {
        self.SelectedTag = sourceView.tag
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        alertController.modalPresentationStyle = .overCurrentContext
        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image, SelectedTag: self.SelectedTag)
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
