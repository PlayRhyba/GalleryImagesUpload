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
    
    /// Number of cells to display
    ///
    /// - Returns: number of cells
    func numberOfCells() -> Int
    
    /// Cell presenter at specific index path
    ///
    /// - Parameter indexPath: index path
    /// - Returns: cell presenter
    func cellPresenter(at indexPath: IndexPath) -> GalleryCellPresenterProtocol?
    
    /// Select cell at index path
    ///
    /// - Parameter indexPath: index path
    func selectCell(at indexPath: IndexPath)
    
    /// Delete cell at index path
    ///
    /// - Parameter indexPath: index path
    func deleteCell(at indexPath: IndexPath)
    
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
    
    /// Reload view's content
    func reloadData()
    
    /// Update placeholder visibility
    ///
    /// - Parameter isHidden: is placeholder hidden
    func updatePlaceholder(isHidden: Bool)
    
    /// Show selected image
    ///
    /// - Parameter artist: artist
    func show(image: Image)
    
}

protocol GalleryCellPresenterProtocol: PresenterProtocol {
    
    /// Image
    var image: Image { get }
    
}

protocol GalleryCellViewProtocol: ViewProtocol {
    
    /// Update cell's contents
    ///
    /// - Parameters:
    ///   - title: title
    ///   - previewURL: preview URL
    func update(title: String?, previewURL: URL?)
    
}
