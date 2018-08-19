//
//  GalleryCellPresenter.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation

final class GalleryCellPresenter: Presenter, GalleryCellPresenterProtocol {
    
    let image: Image
    
    // MARK: Initialization
    
    init(image: Image) {
        self.image = image
    }
    
    // MARK: Presenter
    
    override func viewDidAttach() {
        super.viewDidAttach()
        
        getView()?.update(title: DateFormatter.displaying.string(from: image.date),
                          previewURL: image.preview)
    }
    
}

// MARK: Private

private extension GalleryCellPresenter {
    
    func getView() -> GalleryCellViewProtocol? {
        return view as? GalleryCellViewProtocol
    }
    
}
