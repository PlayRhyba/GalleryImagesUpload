//
//  GalleryCellPresenter.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation

final class GalleryCellPresenter: Presenter {
    
    let image: Image
    
    var state: SelectionState {
        didSet {
            getView()?.update(state: state)
        }
    }
    
    // MARK: Initialization
    
    init(image: Image, state: SelectionState = .none) {
        self.image = image
        self.state = state
    }
    
    // MARK: Presenter
    
    override func viewDidAttach() {
        super.viewDidAttach()
        
        getView()?.update(title: DateFormatter.displaying.string(from: image.date),
                          previewURL: image.preview)
        
        getView()?.update(state: state)
    }
    
}

// MARK: GalleryCellPresenterProtocol

extension GalleryCellPresenter: GalleryCellPresenterProtocol {
    
    func toggleState() {
        switch state {
        case .none:
            break
            
        case .selected:
            state = .unselected
            
        case .unselected:
            state = .selected
        }
    }
    
}

// MARK: Private

private extension GalleryCellPresenter {
    
    func getView() -> GalleryCellViewProtocol? {
        return view as? GalleryCellViewProtocol
    }
    
}
