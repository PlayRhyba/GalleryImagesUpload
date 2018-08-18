//
//  ImagesManagerAssembly.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Swinject

final class ImagesManagerAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(DataLoaderProtocol.self) { _ in DataLoader() }
            .inObjectScope(.container)
        
        container.register(ImageDatabaseProtocol.self) { c in
            let dataLoader = c.resolve(DataLoaderProtocol.self)!
            
            return ImageDatabase(dataLoader: dataLoader)
            }.inObjectScope(.container)
        
        container.register(ImageDataProcessorProtocol.self) { _ in ImageDataProcessor() }
            .inObjectScope(.container)
        
        container.register(ImagesManagerProtocol.self) { c in
            let dataLoader = c.resolve(DataLoaderProtocol.self)!
            let imageDatabase = c.resolve(ImageDatabaseProtocol.self)!
            let imageDataProcessor = c.resolve(ImageDataProcessorProtocol.self)!
            
            return ImagesManager(dataLoader: dataLoader,
                                 imageDatabase: imageDatabase,
                                 imageDataProcessor: imageDataProcessor)
            }.inObjectScope(.container)
    }
    
}
