//
//  DataUploaderProtocol.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation

protocol DataUploaderProtocol {
    
    /// Upload data and store on specific path
    ///
    /// - Parameters:
    ///   - data: data to upload
    ///   - path: path
    ///   - progress: progress
    ///   - completion: completion handler
    func upload(data: Data,
                path: String,
                progress: ((Progress?) -> Void)?,
                completion: @escaping (OperationResult<URL, OperationError>) -> Void)
    
}
