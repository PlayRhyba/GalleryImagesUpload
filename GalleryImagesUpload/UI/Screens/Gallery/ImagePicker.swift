//
//  ImagePicker.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit
import AVKit
import CropViewController

final class ImagePicker: NSObject {
    
    typealias Completion = (UIImage?) -> Void
    
    private weak var viewController: UIViewController?
    private let sourceType: UIImagePickerControllerSourceType
    private let completion: Completion
    
    // MARK: Initialization
    
    init(viewController: UIViewController,
         sourceType: UIImagePickerControllerSourceType,
         completion: @escaping Completion) {
        self.viewController = viewController
        self.sourceType = sourceType
        self.completion = completion
    }
    
    // MARK: Public
    
    func show() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                
                if granted {
                    let picker = UIImagePickerController()
                    picker.sourceType = UIImagePickerController.isSourceTypeAvailable(self.sourceType) ? self.sourceType : .photoLibrary
                    picker.delegate = self
                    picker.modalPresentationStyle = .overCurrentContext
                    
                    self.viewController?.present(picker, animated: true)
                } else {
                    self.showAlert(title: "Permission is not allowed",
                                   message: "Please check the app's camera permissions in Settings")
                    
                    self.completion(nil)
                }
            }
        }
    }
    
}

// MARK: UIImagePickerControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            completion(nil)
            
            return
        }
        
        let cropper = CropViewController(image: image)
        cropper.delegate = self
        
        picker.present(cropper, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController?.dismiss(animated: true) { [weak self] in
            self?.completion(nil)
        }
    }
    
}

// MARK: UINavigationControllerDelegate

extension ImagePicker: UINavigationControllerDelegate {}

// MARK: CropViewControllerDelegate

extension ImagePicker: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController,
                            didCropToImage image: UIImage,
                            withRect cropRect: CGRect,
                            angle: Int) {
        
        // TODO: Scale image
        
        viewController?.dismiss(animated: true) { [weak self] in
            self?.completion(image)
        }
    }
    
}

// MARK: Private

private extension ImagePicker {
    
    func showAlert(title: String?, message: String?) {
        guard let viewController = viewController else { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        viewController.present(alert, animated: true)
    }
    
}
