//
//  GalleryPresenter.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

final class GalleryPresenter: ScreenPresenter {
    
    private struct Constants {
        
        static let maxImageDimension: CGFloat = 100
        
    }
    
    private let imagesManager: ImagesManagerProtocol
    private var cellPresenters: [GalleryCellPresenterProtocol] = []
    
    // MARK: Initialization
    
    init(imagesManager: ImagesManagerProtocol) {
        self.imagesManager = imagesManager
    }
    
}

extension GalleryPresenter: GalleryPresenterProtocol {
    
    func add() {
        getView()?.displayImageSourceSelectionActionSheet { [weak self] source in
            self?.getView()?.displayImagePicker(source: source) { image in
                guard let `self` = self,
                    let image = image else { return }
                
                self.getView()?.showHUD()
                
                self.imagesManager.upload(image: (image, image.scaled(to: Constants.maxImageDimension)),
                                          progress: { self.getView()?.showHUD(progress: Float($0?.fractionCompleted ?? 0)) },
                                          completion: { retult in
                                            self.getView()?.dismissHUD()
                })
            }
        }
    }
    
    func numberOfCells() -> Int {
        return cellPresenters.count
    }
    
    func cellPresenter(at indexPath: IndexPath) -> GalleryCellPresenterProtocol? {
        return cellPresenters[indexPath.row]
    }
    
    func selectCell(at indexPath: IndexPath) {
        
    }
    
    func deleteCell(at indexPath: IndexPath) {
        
    }
    
}

// MARK: Private

private extension GalleryPresenter {
    
    func getView() -> GalleryViewProtocol? {
        return view as? GalleryViewProtocol
    }
    
}
