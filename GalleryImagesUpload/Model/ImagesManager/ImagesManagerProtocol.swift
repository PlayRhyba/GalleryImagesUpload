//
//  ImagesManagerProtocol.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

protocol ImagesManagerProtocol {
    
    /// Upload image
    ///
    /// - Parameters:
    ///   - image: image to upload
    ///   - completion: completion handler with updated array of stored images
    func upload(image: UIImage,
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void)
    
    /// Fetch stored images
    ///
    /// - Parameter completion: completion handler with array of stored images
    func fetchImages(completion: @escaping (OperationResult<[Image], OperationError>) -> Void)
    
    /// Remove image
    ///
    /// - Parameters:
    ///   - image: image to removew
    ///   - completion: completion handler with updated array of stored images
    func delete(image: Image,
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void)
    
    /// Remove images
    ///
    /// - Parameters:
    ///   - image: images to removew
    ///   - completion: completion handler with updated array of stored images
    func delete(images: [Image],
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void)
    
}
