//
//  DataLoader.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation
import FirebaseStorage

final class DataLoader {
    
    private let bucket: String?
    
    // MARK: Initialization
    
    init(bucket: String? = nil) {
        self.bucket = bucket
    }
    
}

// MARK: DataLoaderProtocol

extension DataLoader: DataLoaderProtocol {
    
    func upload(data: Data,
                path: String,
                progress: ((Progress?) -> Void)?,
                completion: @escaping (OperationResult<URL, OperationError>) -> Void) {
        let file = storage.reference().child(path)
        
        let task = file.putData(data, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(.dataLoader(error.localizedDescription)))
            } else {
                file.downloadURL { url, error in
                    guard let url = url else {
                        completion(.failure(.dataLoader(error?.localizedDescription ?? "Uploading failed")))
                        
                        return
                    }
                    
                    completion(.success(url))
                }
            }
        }
        
        if let progress = progress {
            task.observe(.progress) { progress($0.progress) }
        }
    }
    
    func download(path: String,
                  maxSize: Int64,
                  progress: ((Progress?) -> Void)?,
                  completion: @escaping (OperationResult<Data, OperationError>) -> Void) {
        let file = storage.reference().child(path)
        
        let task = file.getData(maxSize: maxSize) { data, error in
            if let error = error {
                completion(.failure(.dataLoader(error.localizedDescription)))
            } else {
                guard let data = data else {
                    completion(.failure(.dataLoader("Data can't be downloaded")))
                    
                    return
                }
                
                completion(.success(data))
            }
        }
        
        if let progress = progress {
            task.observe(.progress) { progress($0.progress) }
        }
    }
    
    func delete(path: String,
                completion: @escaping (OperationResult<Void, OperationError>) -> Void) {
        let file = storage.reference().child(path)
        
        file.delete { error in
            if let error = error {
                completion(.failure(.dataLoader(error.localizedDescription)))
            } else {
                completion(.success(()))
            }
        }
    }
    
}

// MARK: Private

private extension DataLoader {
    
    var storage: Storage {
        if let bucket = bucket {
            return Storage.storage(url: bucket)
        } else {
            return Storage.storage()
        }
    }
    
}
