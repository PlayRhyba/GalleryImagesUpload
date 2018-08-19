//
//  PreviewPresenter.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 17/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation

final class PreviewPresenter: ScreenPresenter, PreviewPresenterProtocol {
    
    var image: Image?
    
    // MARK: Presenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = image else { return }
        
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
