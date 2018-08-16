//
//  DataUploader.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation
import FirebaseStorage

final class DataUploader {}

// MARK: DataUploaderProtocol

extension DataUploader: DataUploaderProtocol {
    
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
    
}
