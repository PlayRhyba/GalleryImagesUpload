//
//  DataLoaderProtocol.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation

protocol DataLoaderProtocol {
    
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
    
    /// Download file's data on specific path
    ///
    /// - Parameters:
    ///   - path: path to file
    ///   - maxSize: maximum size of file
    ///   - progress: progress
    ///   - completion: completion handler
    func download(path: String,
                  maxSize: Int64,
                  progress: ((Progress?) -> Void)?,
                  completion: @escaping (OperationResult<Data, OperationError>) -> Void)
    
    /// Remove file on specific path
    ///
    /// - Parameters:
    ///   - path: path to file
    ///   - completion: completion handler
    func delete(path: String,
                completion: @escaping (OperationResult<Void, OperationError>) -> Void)
    
}

extension DataLoaderProtocol {
    
    func upload(data: Data,
                path: String,
                completion: @escaping (OperationResult<URL, OperationError>) -> Void) {
        upload(data: data,
               path: path,
               progress: nil,
               completion: completion)
    }
    
    func download(path: String,
                  maxSize: Int64,
                  completion: @escaping (OperationResult<Data, OperationError>) -> Void) {
        download(path: path,
                 maxSize: maxSize,
                 progress: nil,
                 completion: completion)
    }
    
}
