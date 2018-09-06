//
//  ImageDatabase.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 18/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation

final class ImageDatabase {
    
    private struct Constants {
        
        static let contentsFilePath = "contents.json"
        static let maxDownloadingFileSize: Int64 = 5 * 1024 * 1024
        
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

// MARK: ImageDatabaseProtocol

extension ImageDatabase: ImageDatabaseProtocol {
    
    func fetch(completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        dataLoader.download(path: Constants.contentsFilePath,
                            maxSize: Constants.maxDownloadingFileSize) { [weak self] result in
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
    
    func add(images: [Image],
             completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        updateContentFile(modification: .add, images: images, completion: completion)
    }
    
    func delete(images: [Image],
                completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        updateContentFile(modification: .delete, images: images, completion: completion)
    }
    
}

// MARK: Private

private extension ImageDatabase {
    
    enum ContentFileModificationType {
        
        case add
        case delete
        
    }
    
    func updateContentFile(modification: ContentFileModificationType,
                           images: [Image],
                           completion: @escaping (OperationResult<[Image], OperationError>) -> Void) {
        fetch { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(var resultImages):
                switch modification {
                case .add:
                    resultImages.append(contentsOf: images)
                    
                case .delete:
                    resultImages = resultImages.filter { !images.contains($0) }
                }
                
                guard let data = try? self.jsonEncoder.encode(resultImages) else {
                    completion(.failure(.serialization("Data can't be encoded")))
                    
                    break
                }
                
                self.dataLoader.upload(data: data, path: Constants.contentsFilePath) { result in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                        
                    case .success:
                        completion(.success(resultImages))
                    }
                }
            }
        }
    }
    
}
