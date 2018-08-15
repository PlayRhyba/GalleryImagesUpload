//
//  GalleryAssembly.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Swinject

final class GalleryAssembly: Assembly {
    
    func assemble(container: Container) {
        container.storyboardInitCompleted(GalleryViewController.self) { r, vc in
            vc.presenter = r.resolve(GalleryPresenterProtocol.self)
        }
        
        container.register(GalleryPresenterProtocol.self) { c in
            return GalleryPresenter()
        }
    }
    
}
