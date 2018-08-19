//
//  ImageDatabaseStub.swift
//  GalleryImagesUploadTests
//
//  Created by Alexander Snegursky on 18/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

@testable import GalleryImagesUpload

final class ImageDatabaseStub {
    
    typealias FetchStub = () -> (OperationResult<[Image], OperationError>)
    typealias ImageStub = (Image) -> (OperationResult<[Image], OperationError>)
    
    var fetchStub: FetchStub?
    var addStub: ImageStub?
    var deleteStub: ImageStub?
    
}

// MARK: ImageDatabaseProtocol

extension ImageDatabaseStub: ImageDatabaseProtocol {
    
    func fetch(completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        guard let fetchStub = fetchStub else { return }
        
        completion(fetchStub())
    }
    
    func add(image: Image,
             completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        guard let addStub = addStub else { return }
        
        completion(addStub(image))
    }
    
    func delete(image: Image,
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        guard let deleteStub = deleteStub else { return }
        
        completion(deleteStub(image))
    }
    
}
