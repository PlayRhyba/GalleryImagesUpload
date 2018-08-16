//
//  DataLoader.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation
import FirebaseStorage

final class DataLoader {}

// MARK: DataLoaderProtocol

extension DataLoader: DataLoaderProtocol {
    
    func upload(data: Data,
                path: String,
                progress: ((Progress?) -> Void)?,
                completion: @escaping (OperationResult<URL, OperationError>) -> Void) {
        let fileRef = Storage.storage().reference().child(path)
        
        let task = fileRef.putData(data, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(.loading(error.localizedDescription)))
            } else {
                fileRef.downloadURL { url, error in
                    guard let url = url else {
                        completion(.failure(.loading(error?.localizedDescription ?? "Uploading failed")))
                        
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
        let fileRef = Storage.storage().reference().child(path)
        
        let task = fileRef.getData(maxSize: maxSize) { data, error in
            if let error = error {
                completion(.failure(.loading(error.localizedDescription)))
            } else {
                guard let data = data else {
                    completion(.failure(.loading("Data can't be downloaded")))
                    
                    return
                }
                
                completion(.success(data))
            }
        }
        
        if let progress = progress {
            task.observe(.progress) { progress($0.progress) }
        }
    }
    
}
