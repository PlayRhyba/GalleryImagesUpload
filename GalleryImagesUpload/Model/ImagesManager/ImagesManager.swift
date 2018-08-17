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
        static let imagesFolder = "images"
        static let originalFileSuffix = "original"
        static let previewFileSuffix = "preview"
        static let imageFileExtension = "jpg"
        static let contentsFileName = "contents.json"
        
    }
    
    private enum ContentFileModificationType {
        
        case add
        case remove
        
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
    
    func upload(image: UIImage,
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        makeData(from: image) { [weak self] (originalImageData, previewImageData) in
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
                            
                            self?.updateContentFile(modification: .add,
                                                    image: image,
                                                    completion: completion)
                        }
                    }
                }
            }
        }
    }
    
    func fetchImages(completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        dataLoader.download(path: Constants.contentsFileName) { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let data):
                guard let images = try? self.jsonDecoder.decode([Image].self, from: data) else {
                    completion(.failure(.serialization("Data can't be decoded")))
                    
                    break
                }
                
                completion(.success(images))
            }
        }
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
                        self?.updateContentFile(modification: .remove,
                                                image: image,
                                                completion: completion)
                    }
                }
            }
        }
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
    
    func makeData(from image: UIImage,
                  completion: @escaping (Data?, Data?) -> Void) {
        DispatchQueue.global().async {
            let previewImage = image.scaled(to: GlobalConstants.maxPreviewImageDimension)
            
            let originalImageData = UIImageJPEGRepresentation(image, Constants.jpegCompretionQuality)
            let previewImageData = UIImageJPEGRepresentation(previewImage, Constants.jpegCompretionQuality)
            
            DispatchQueue.main.async {
                completion(originalImageData, previewImageData)
            }
        }
    }
    
    private func updateContentFile(modification: ContentFileModificationType,
                                   image: Image,
                                   completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        fetchImages { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(var images):
                switch modification {
                case .add:
                    images.append(image)
                    
                case .remove:
                    images = images.filter { $0.uuid != image.uuid }
                }
                
                guard let data = try? self.jsonEncoder.encode(images) else {
                    completion(.failure(.serialization("Data can't be encoded")))
                    
                    break
                }
                
                self.dataLoader.upload(data: data, path: Constants.contentsFileName) { result in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                        
                    case .success:
                        completion(.success(images))
                    }
                }
            }
        }
    }
    
}
