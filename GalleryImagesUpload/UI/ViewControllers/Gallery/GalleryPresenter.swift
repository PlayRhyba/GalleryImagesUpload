//
//  GalleryPresenter.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

final class GalleryPresenter: ScreenPresenter {
    
    private let imagesManager: ImagesManagerProtocol
    private var cellPresenters: [GalleryCellPresenterProtocol] = []
    
    // MARK: Initialization
    
    init(imagesManager: ImagesManagerProtocol) {
        self.imagesManager = imagesManager
    }
    
    // MARK: Presenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getView()?.showHUD(status: "Fetching images...")
        
        imagesManager.fetchImages { [weak self] result in
            self?.getView()?.dismissHUD()
            self?.handleFetchResult(result)
        }
    }
    
}

extension GalleryPresenter: GalleryPresenterProtocol {
    
    func add() {
        getView()?.displayImageSourceSelectionActionSheet { [weak self] source in
            self?.getView()?.displayImagePicker(source: source) { image in
                guard let `self` = self,
                    let image = image else { return }
                
                self.getView()?.showHUD(status: "Uploading image...")
                
                self.imagesManager.upload(image: image) { [weak self] result in
                    self?.getView()?.dismissHUD()
                    self?.handleFetchResult(result)
                }
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
        let image = cellPresenters[indexPath.row].image
        getView()?.show(image: image)
    }
    
    func deleteCell(at indexPath: IndexPath) {
        let image = cellPresenters[indexPath.row].image
        
        getView()?.showHUD(status: "Removing image...")
        
        imagesManager.delete(image: image) { [weak self] result in
            self?.getView()?.dismissHUD()
            self?.handleFetchResult(result)
        }
    }
    
}

// MARK: Private

private extension GalleryPresenter {
    
    func getView() -> GalleryViewProtocol? {
        return view as? GalleryViewProtocol
    }
    
    func reloadData(images: [Image]) {
        cellPresenters = images
            .sorted { $0 > $1 }
            .map { GalleryCellPresenter(image: $0) }
        
        getView()?.reloadData()
        getView()?.updatePlaceholder(isHidden: !cellPresenters.isEmpty)
    }
    
    func handleFetchResult(_ result: OperationResult<[Image], OperationError>) {
        switch result {
        case .success(let images):
            self.reloadData(images: images)
            
        case .failure(let error):
            self.getView()?.show(errorMessage: error.message)
        }
    }
    
}
