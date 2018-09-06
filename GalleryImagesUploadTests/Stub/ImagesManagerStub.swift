//
//  ImagesManagerStub.swift
//  GalleryImagesUploadTests
//
//  Created by Alexander Snegursky on 18/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

@testable import GalleryImagesUpload

final class ImagesManagerStub {
    
    typealias UploadStub = (UIImage) -> (OperationResult<[Image], OperationError>)
    typealias FetchStub = () -> (OperationResult<[Image], OperationError>)
    typealias DeleteStub = (Image) -> (OperationResult<[Image], OperationError>)
    
    var uploadStub: UploadStub?
    var fetchStub: FetchStub?
    var deleteStub: DeleteStub?
    
}

// MARK: ImagesManagerProtocol

extension ImagesManagerStub: ImagesManagerProtocol {
    
    func upload(image: UIImage,
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        guard let uploadStub = uploadStub else { return }
        
        completion(uploadStub(image))
    }
    
    func fetchImages(completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        guard let fetchStub = fetchStub else { return }
        
        completion(fetchStub())
    }
    
    func delete(image: Image,
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        guard let deleteStub = deleteStub else { return }
        
        completion(deleteStub(image))
    }
    
    func delete(images: [Image],
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {}
    
}
