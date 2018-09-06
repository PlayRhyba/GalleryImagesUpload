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
    
    var state: SelectionState = .none {
        didSet {
            getView()?.update(state: state)
            delegate?.didChangeState(cell: self)
        }
    }
    
    weak var delegate: GalleryCellDelegate?
    
    // MARK: Initialization
    
    init(image: Image, delegate: GalleryCellDelegate? = nil) {
        self.image = image
        self.delegate = delegate
    }
    
    // MARK: Presenter
    
    override func viewDidAttach() {
        super.viewDidAttach()
        
        getView()?.update(title: DateFormatter.displaying.string(from: image.date),
                          previewURL: image.preview)
    }
    
}

// MARK: GalleryCellPresenterProtocol

extension GalleryCellPresenter: GalleryCellPresenterProtocol {
    
    func handleSelection() {
        switch state {
        case .none:
            delegate?.didSelect(cell: self)
            
        case .selected(let selected):
            state = .selected(!selected)
            getView()?.update(state: state)
            delegate?.didChangeState(cell: self)
        }
    }
    
}

// MARK: Private

private extension GalleryCellPresenter {
    
    func getView() -> GalleryCellViewProtocol? {
        return view as? GalleryCellViewProtocol
    }
    
}
