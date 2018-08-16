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
        container.register(DataUploaderProtocol.self) { _ in DataUploader() }
            .inObjectScope(.container)
        
        container.register(ImagesManagerProtocol.self) { c in
            let dataUploader = c.resolve(DataUploaderProtocol.self)!
            
            return ImagesManager(dataUploader: dataUploader)
            }.inObjectScope(.container)
    }
    
}
