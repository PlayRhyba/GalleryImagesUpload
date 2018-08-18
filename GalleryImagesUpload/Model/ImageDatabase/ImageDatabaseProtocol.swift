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
    ///   - image: image object
    ///   - completion: completion handler
    func add(image: Image,
             completion: @escaping (OperationResult<[Image], OperationError>) -> Void)
    
    /// Delete image
    ///
    /// - Parameters:
    ///   - image: image object
    ///   - completion: completion handler
    func delete(image: Image,
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void)
    
}
