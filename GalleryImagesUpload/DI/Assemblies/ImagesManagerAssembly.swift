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
        
        container.register(ImagesManagerProtocol.self) { c in
            let dataLoader = c.resolve(DataLoaderProtocol.self)!
            
            return ImagesManager(dataLoader: dataLoader)
            }.inObjectScope(.container)
    }
    
}
