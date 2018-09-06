//
//  PreviewPresenter.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 17/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation

final class PreviewPresenter: ScreenPresenter {
    
    var images: [Image]?
    
    var index: Int = 0
    
    // MARK: Presenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = images?[index] else { return }
        
        getView()?.update(title: DateFormatter.displaying.string(from: image.date),
                          imageURL: image.original)
    }
    
}

extension PreviewPresenter: PreviewPresenterProtocol {
    
    func presentNext() {
        guard let images = images,
            index < images.count else { return }
        
        index += 1
        
        let image = images[index]
        
        getView()?.update(title: DateFormatter.displaying.string(from: image.date),
                          imageURL: image.original)
    }
    
    func presentPrevious() {
        guard let images = images,
            index > 0 else { return }
        
        index -= 1
        
        let image = images[index]
        
        getView()?.update(title: DateFormatter.displaying.string(from: image.date),
                          imageURL: image.original)
    }
    
}

// MARK: Private

private extension PreviewPresenter {
    
    func getView() -> PreviewViewProtocol? {
        return view as? PreviewViewProtocol
    }
    
}
