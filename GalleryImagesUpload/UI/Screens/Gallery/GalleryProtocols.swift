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
    func handleSelectionOnCell(at indexPath: IndexPath)
    
    /// Handle the long press on cell at index path
    ///
    /// - Parameter indexPath: indexPath
    func handleLongPressOnCell(at indexPath: IndexPath)
    
    func cancel()
    
    func delete()
    
}

/// Source for image to select
///
/// - library: photo library
/// - camera: camera
enum ImageSource {
    
    case library
    case camera
    
}

enum SelectionState {
    
    case none
    case selected(Bool)
    
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
    
    /// Show delete confirmation alert
    ///
    /// - Parameter confirmed: action handler
    func showDeleteConfirmationAlert(confirmed: @escaping (Bool) -> Void)
    
    /// Reload view's content
    func reloadData()
    
    /// Update placeholder visibility
    ///
    /// - Parameter isHidden: is placeholder hidden
    func updatePlaceholder(isHidden: Bool)
    
    /// Update view operation state
    ///
    /// - Parameter state: view operation state
    func update(state: SelectionState)
    
    /// Show selected image
    ///
    /// - Parameter artist: artist
    func show(images: [Image], index: Int)
    
}

protocol GalleryCellDelegate: class {
    
    func didChangeState(cell: GalleryCellPresenterProtocol)
    
    func didSelect(cell: GalleryCellPresenterProtocol)
    
}

protocol GalleryCellPresenterProtocol: PresenterProtocol {
    
    /// Image
    var image: Image { get }
    
    var delegate: GalleryCellDelegate? { get }
    
    var state: SelectionState { get set }
    
    func handleSelection()
    
}

protocol GalleryCellViewProtocol: ViewProtocol {
    
    /// Update cell's contents
    ///
    /// - Parameters:
    ///   - title: title
    ///   - previewURL: preview URL
    func update(title: String?, previewURL: URL?)
    
    /// Update selection state
    ///
    /// - Parameter state: state
    func update(state: SelectionState)
    
}
