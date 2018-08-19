//
//  DataLoaderStub.swift
//  GalleryImagesUploadTests
//
//  Created by Alexander Snegursky on 18/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation

@testable import GalleryImagesUpload

final class DataLoaderStub {
    
    typealias UploadStub = ((Data, String) -> OperationResult<URL, OperationError>)
    typealias DownloadStub = ((String) -> OperationResult<Data, OperationError>)
    typealias DeleteStub = ((String) -> OperationResult<Void, OperationError>)
    
    var uploadStub: UploadStub?
    var downloadStub: DownloadStub?
    var deleteStub: DeleteStub?
    
}

// MARK: DataLoaderProtocol

extension DataLoaderStub: DataLoaderProtocol {
    
    func upload(data: Data,
                path: String,
                progress: ((Progress?) -> Void)?,
                completion: @escaping (OperationResult<URL, OperationError>) -> Void) {
        guard let uploadStub = uploadStub else { return }
        
        completion(uploadStub(data, path))
    }
    
    func download(path: String,
                  maxSize: Int64,
                  progress: ((Progress?) -> Void)?,
                  completion: @escaping (OperationResult<Data, OperationError>) -> Void) {
        guard let downloadStub = downloadStub else { return }
        
        completion(downloadStub(path))
    }
    
    func delete(path: String,
                completion: @escaping (OperationResult<Void, OperationError>) -> Void) {
        guard let deleteStub = deleteStub else { return }
        
        completion(deleteStub(path))
    }
    
}
