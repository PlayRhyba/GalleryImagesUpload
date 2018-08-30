//
//  GalleryViewSpy.swift
//  GalleryImagesUploadTests
//
//  Created by Alexander Snegursky on 19/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

@testable import GalleryImagesUpload

final class GalleryViewSpy {
    
    typealias ImageSourceStub = () -> (ImageSource)
    typealias ImageStub = (ImageSource) -> (UIImage?)
    typealias DeleteConfirmationStub = () -> Bool
    
    var displayImageSourceSelectionActionSheetStub: ImageSourceStub?
    var displayImagePickerStub: ImageStub?
    var showDeleteConfirmationAlertStub: DeleteConfirmationStub?
    var reloadDataInvoked = false
    var updatePlaceholderInvocation: (invoked: Bool, isHidden: Bool?) = (false, nil)
    var showImageInvocation: (invoked: Bool, image: Image?) = (false, nil)
    var showHUDInvoked = false
    var showErrorMessageInvocation: (invoked: Bool, errorMessage: String?) = (false, nil)
    var dismissHUDInvoked = false
    
}

// MARK: GalleryViewProtocol

extension GalleryViewSpy: GalleryViewProtocol {
    
    func displayImageSourceSelectionActionSheet(completion: @escaping (ImageSource) -> Void) {
        guard let stub = displayImageSourceSelectionActionSheetStub else { return }
        
        completion(stub())
    }
    
    func displayImagePicker(source: ImageSource, completion: @escaping (UIImage?) -> Void) {
        guard let stub = displayImagePickerStub else { return }
        
        completion(stub(source))
    }
    
    func showDeleteConfirmationAlert(confirmed: @escaping (Bool) -> Void) {
        guard let stub = showDeleteConfirmationAlertStub else { return }
        
        confirmed(stub())
    }
    
    func reloadData() {
        reloadDataInvoked = true
    }
    
    func updatePlaceholder(isHidden: Bool) {
        updatePlaceholderInvocation = (true, isHidden)
    }
    
    func show(image: Image) {
        showImageInvocation = (true, image)
    }
    
}

// MARK: ScreenViewProtocol

extension GalleryViewSpy: ScreenViewProtocol {
    
    func showHUD(status: String?) {
        showHUDInvoked = true
    }
    
    func show(errorMessage: String?) {
        showErrorMessageInvocation = (true, errorMessage)
    }
    
    func dismissHUD() {
        dismissHUDInvoked = true
    }
    
}

