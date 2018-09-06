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
    var updateStateInvocation: (invoked: Bool, state: SelectionState?) = (false, nil)
    var showImagesInvocation: (invoked: Bool, images: [Image]?, index: Int?) = (false, nil, nil)
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
    
    func update(state: SelectionState) {
        updateStateInvocation = (true, state)
    }
    
    func show(images: [Image], index: Int) {
        showImagesInvocation = (true, images, index)
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

