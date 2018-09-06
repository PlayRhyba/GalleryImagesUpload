//
//  ImageDatabaseProtocol.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 18/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

protocol ImageDatabaseProtocol {
    
    /// Fetch existing images
    ///
    /// - Parameter completion: completion handler
    func fetch(completion: @escaping (OperationResult<[Image], OperationError>) -> Void)
    
    /// Add image
    ///
    /// - Parameters:
    ///   - images: collection of image objects
    ///   - completion: completion handler
    func add(images: [Image],
             completion: @escaping (OperationResult<[Image], OperationError>) -> Void)
    
    /// Delete image
    ///
    /// - Parameters:
    ///   - image: collection of image objects
    ///   - completion: completion handler
    func delete(images: [Image],
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void)
    
}
