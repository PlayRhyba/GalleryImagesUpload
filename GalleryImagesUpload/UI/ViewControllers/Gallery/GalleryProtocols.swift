//
//  GalleryProtocols.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

protocol GalleryPresenterProtocol: ScreenPresenterProtocol {
    
    /// Add photo
    func add()
    
}

/// Source for image to select
///
/// - library: photo library
/// - camera: camera
enum ImageSource {
    
    case library
    case camera
    
}

protocol GalleryViewProtocol: ScreenViewProtocol {
    
    /// Display image source selection action sheet
    ///
    /// - Parameter completion: completion handler with selected image source
    func displayImageSourceSelectionActionSheet(completion: @escaping (ImageSource) -> Void)
    
    /// Display image picker
    ///
    /// - Parameters:
    ///   - source: source of image
    ///   - completion: completion handler with selected image
    func displayImagePicker(source: ImageSource, completion: @escaping (UIImage?) -> Void)
    
}
