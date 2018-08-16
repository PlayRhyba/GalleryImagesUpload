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
        
        static let jpegCompretionQuality: CGFloat = 0.85
        static let contentsFileName = "contents.json"
        static let imagesFolderName = "images"
        static let originalFileNameSuffix = "original"
        static let previewFileNameSuffix = "preview"
        static let imageFileExtension = "jpg"
        
    }
    
    private let dataLoader: DataLoaderProtocol
    
    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        return encoder
    }()
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()
    
    // MARK: Initialization
    
    init(dataLoader: DataLoaderProtocol) {
        self.dataLoader = dataLoader
    }
    
}

// MARK: ImagesManagerProtocol

extension ImagesManager: ImagesManagerProtocol {
    
    func upload(image: (original: UIImage, preview: UIImage),
                progress: ((Progress?) -> Void)?,
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        guard let originalImageData = UIImageJPEGRepresentation(image.original, Constants.jpegCompretionQuality),
            let previewImageData = UIImageJPEGRepresentation(image.preview, Constants.jpegCompretionQuality) else {
                completion(.failure(.serialization("Can't serialize image to JPEG")))
                
                return
        }
        
        let uuid = UUID().uuidString
        var urls = Image.URLs()
        
        dataLoader.upload(data: originalImageData,
                          path: makeImageFilePath(uuid: uuid, suffix: Constants.originalFileNameSuffix),
                          progress: progress) { [weak self] in
                            guard let `self` = self else { return }
                            
                            switch $0 {
                            case .failure(let error):
                                completion(.failure(error))
                                
                            case.success(let url):
                                urls.original = url
                                
                                self.dataLoader.upload(data: previewImageData,
                                                       path: self.makeImageFilePath(uuid: uuid, suffix: Constants.previewFileNameSuffix),
                                                       progress: progress) {
                                                        switch $0 {
                                                        case .failure(let error):
                                                            completion(.failure(error))
                                                            
                                                        case .success(let url):
                                                            urls.preview = url
                                                            
                                                            let image = Image(uuid: uuid, date: Date(), urls: urls)
                                                            
                                                            // TODO: get current content
                                                            
                                                            // TODO: update current content
                                                            
                                                            completion(.success([image]))
                                                        }
                                }
                            }
        }
    }
    
    func fetchImages(completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        
    }
    
}

// MARK: Private

private extension ImagesManager {
    
    var contentsFilePath: String {
        return "\(Constants.imagesFolderName)/\(Constants.contentsFileName)"
    }
    
    func makeImageFilePath(uuid: String, suffix: String) -> String {
        return "\(Constants.imagesFolderName)/\(uuid)_\(suffix).\(Constants.imageFileExtension)"
    }
    
}
