//
//  ImagesManager.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

final class ImagesManager {
    
    private struct Constants {
        
        static let imagesFolder = "images"
        static let originalFileSuffix = "original"
        static let previewFileSuffix = "preview"
        static let imageFileExtension = "jpg"
        
    }
    
    private let dataLoader: DataLoaderProtocol
    private let imageDatabase: ImageDatabaseProtocol
    private let imageDataProcessor: ImageDataProcessorProtocol
    
    // MARK: Initialization
    
    init(dataLoader: DataLoaderProtocol,
         imageDatabase: ImageDatabaseProtocol,
         imageDataProcessor: ImageDataProcessorProtocol) {
        self.dataLoader = dataLoader
        self.imageDatabase = imageDatabase
        self.imageDataProcessor = imageDataProcessor
    }
    
}

// MARK: ImagesManagerProtocol

extension ImagesManager: ImagesManagerProtocol {
    
    func upload(image: UIImage,
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        imageDataProcessor.makeData(from: image) { [weak self] (originalImageData, previewImageData) in
            guard let `self` = self else { return }
            
            guard let originalImageData = originalImageData,
                let previewImageData = previewImageData else {
                    completion(.failure(.serialization("Can't serialize image to JPEG")))
                    
                    return
            }
            
            let uuid = UUID().uuidString
            var urls: (original: URL?, preview: URL?) = (nil, nil)
            let paths = self.makePaths(uuid: uuid)
            
            self.dataLoader.upload(data: originalImageData, path: paths.original) { [weak self] result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                    
                case.success(let url):
                    urls.original = url
                    
                    self?.dataLoader.upload(data: previewImageData, path: paths.preview) { [weak self] result in
                        switch result {
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success(let url):
                            urls.preview = url
                            
                            let image = Image(uuid: uuid,
                                              date: Date(),
                                              original: urls.original,
                                              preview: urls.preview)
                            
                            self?.imageDatabase.add(images: [image], completion: completion)
                        }
                    }
                }
            }
        }
    }
    
    func fetchImages(completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        imageDatabase.fetch(completion: completion)
    }
    
    func delete(image: Image,
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        let paths = makePaths(uuid: image.uuid)
        
        dataLoader.delete(path: paths.original) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(.dataLoader(error.localizedDescription)))
                
            case .success:
                self?.dataLoader.delete(path: paths.preview) { [weak self] result in
                    switch result {
                    case .failure(let error):
                        completion(.failure(.dataLoader(error.localizedDescription)))
                        
                    case .success:
                        self?.imageDatabase.delete(images: [image], completion: completion)
                    }
                }
            }
        }
    }
    
    func delete(images: [Image],
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        imageDatabase.delete(images: images, completion: completion)
    }
    
}

// MARK: Private

private extension ImagesManager {
    
    func makeImageFilePath(uuid: String, suffix: String) -> String {
        return "\(Constants.imagesFolder)/\(uuid)_\(suffix).\(Constants.imageFileExtension)"
    }
    
    func makePaths(uuid: String) -> (original: String, preview: String) {
        return (makeImageFilePath(uuid: uuid, suffix: Constants.originalFileSuffix),
                makeImageFilePath(uuid: uuid, suffix: Constants.previewFileSuffix))
    }
    
}
