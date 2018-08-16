//
//  ImagesManagerProtocol.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

protocol ImagesManagerProtocol {
    
    /// Upload image. Image is represented by original and preview images
    ///
    /// - Parameters:
    ///   - image: original and preview images
    ///   - progress: progress
    ///   - completion: completion handler with updated array of stored images
    func upload(image: (original: UIImage, preview: UIImage),
                progress: ((Progress?) -> Void)?,
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void)
    
    /// Fetch stored images
    ///
    /// - Parameter completion: completion handler with array of stored images
    func fetchImages(completion: @escaping (OperationResult<[Image], OperationError>) -> Void)
    
}
