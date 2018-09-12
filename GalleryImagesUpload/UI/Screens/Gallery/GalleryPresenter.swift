//
//  GalleryPresenter.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

final class GalleryPresenter: ScreenPresenter {
    
    var state: SelectionState = .none {
        didSet {
            getView()?.update(state: state)
        }
    }
    
    private let imagesManager: ImagesManagerProtocol
    private var cellPresenters: [GalleryCellPresenterProtocol] = []
    
    // MARK: Initialization
    
    init(imagesManager: ImagesManagerProtocol) {
        self.imagesManager = imagesManager
    }
    
    // MARK: Presenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getView()?.update(state: state)
        
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
        let index = indexPath.row
        
        if state == .none {
            let images = cellPresenters.map { $0.image }
            
            getView()?.show(images: images, index: index)
        } else {
            selectCell(at: index)
        }
    }
    
    func handleLongPressOnCell(at indexPath: IndexPath) {
        guard state == .none else { return }
        
        cellPresenters.forEach { $0.state = .unselected }
        state = .unselected
        
        getView()?.reloadData()
    }
    
    func cancel() {
        cellPresenters.forEach { $0.state = .none }
        state = .none
        
        getView()?.reloadData()
    }
    
    func delete() {
        let images = cellPresenters
            .filter { $0.state == .selected }
            .map { $0.image }
        
        guard !images.isEmpty else { return }
        
        getView()?.showDeleteConfirmationAlert { [weak self] confirmed in
            guard confirmed,
                let `self` = self else { return }
            
            self.getView()?.showHUD(status: "Removing images...")
            
            self.imagesManager.delete(images: images) { [weak self] result in
                self?.getView()?.dismissHUD()
                self?.handleFetchResult(result)
                self?.cancel()
            }
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
            .sorted(by: >)
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
    
    func selectCell(at index: Int) {
        cellPresenters.enumerated().forEach { i, presenter in
            if i == index {
                presenter.toggleState()
            }
        }
        
        getView()?.reloadData()
        
        let newState: SelectionState = {
            let notIdle = cellPresenters
                .map { $0.state }
                .filter { $0 == .selected || $0 == .unselected }
            
            if notIdle.isEmpty {
                return .none
            }
            
            if notIdle.contains(where: ({ $0 == .selected })) {
                return .selected
            }
            
            return .unselected
        }()
        
        state = newState
    }
    
}
