//
//  DependencyManager.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class DependencyManager {
    
    static func makeContainer() -> Container {
        let container = SwinjectStoryboard.defaultContainer
        
        let assemblies: [Assembly] = [ImagesManagerAssembly(),
                                      GalleryAssembly()]
        
        _ = Assembler(assemblies, container: container)
        
        return container
    }
    
}
