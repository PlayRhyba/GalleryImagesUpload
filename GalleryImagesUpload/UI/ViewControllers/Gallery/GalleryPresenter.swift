//
//  GalleryPresenter.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

final class GalleryPresenter: ScreenPresenter {
    
}

extension GalleryPresenter: GalleryPresenterProtocol {
    
    func add() {
        getView()?.displayImageSourceSelectionActionSheet { [weak self] source in
            self?.getView()?.displayImagePicker(source: source) { image in
                
            }
        }
    }
    
}

// MARK: Private

private extension GalleryPresenter {
    
    func getView() -> GalleryViewProtocol? {
        return view as? GalleryViewProtocol
    }
    
}
