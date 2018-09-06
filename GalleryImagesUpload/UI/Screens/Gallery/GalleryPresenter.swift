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
        
        getView()?.update(state: .none)
        
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
    
    func handleSelectionOnCell(at indexPath: IndexPath) {
        let presenter = cellPresenters[indexPath.row]
        presenter.handleSelection()
    }
    
    func handleLongPressOnCell(at indexPath: IndexPath) {
        cellPresenters.forEach { $0.state = .selected(false) }
    }
    
    func cancel() {
        cellPresenters.forEach { $0.state = .none }
    }
    
    func delete() {
        let images = self.cellPresenters
            .filter {
                if case .selected(let selected) = $0.state, selected {
                    return true
                }
                
                return false
            }
            .map { $0.image }
        
        guard !images.isEmpty else { return }
        
        getView()?.showDeleteConfirmationAlert { [weak self] confirmed in
            guard confirmed,
                let `self` = self else { return }
            
            self.getView()?.showHUD(status: "Removing images...")
            
            self.imagesManager.delete(images: images) { [weak self] result in
                self?.getView()?.dismissHUD()
                self?.cancel()
                self?.handleFetchResult(result)
            }
        }
    }
    
}

extension GalleryPresenter: GalleryCellDelegate {
    
    func didChangeState(cell: GalleryCellPresenterProtocol) {
        getView()?.reloadData()
        
        let state: SelectionState = {
            let selected = cellPresenters.filter {
                if case .selected = $0.state {
                    return true
                }
                
                return false
            }
            
            if selected.isEmpty {
                return .none
            }
            
            if selected.contains(where: {
                if case .selected(let selected) = $0.state, selected {
                    return true
                }
                
                return false
            }) {
                return .selected(true)
            }
            
            return .selected(false)
        }()
        
        getView()?.update(state: state)
    }
    
    func didSelect(cell: GalleryCellPresenterProtocol) {
        getView()?.show(image: cell.image)
    }
    
}

// MARK: Private

private extension GalleryPresenter {
    
    func getView() -> GalleryViewProtocol? {
        return view as? GalleryViewProtocol
    }
    
    func reloadData(images: [Image]) {
        cellPresenters = images
            .sorted(by: >)
            .map { GalleryCellPresenter(image: $0, delegate: self) }
        
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
