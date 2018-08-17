//
//  PreviewAssembly.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 17/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Swinject

final class PreviewAssembly: Assembly {
    
    func assemble(container: Container) {
        container.storyboardInitCompleted(PreviewViewController.self) { r, vc in
            vc.presenter = r.resolve(PreviewPresenterProtocol.self)
        }
        
        container.register(PreviewPresenterProtocol.self) { _ in PreviewPresenter() }
    }
    
}
