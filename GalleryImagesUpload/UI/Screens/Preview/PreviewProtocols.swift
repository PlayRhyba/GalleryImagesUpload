//
//  PreviewProtocols.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 17/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation

protocol PreviewPresenterProtocol: ScreenPresenterProtocol {
    
    /// Image to display
    var image: Image? { get set }
    
}

protocol PreviewViewProtocol: ScreenViewProtocol {
    
    /// Update screen's contents
    ///
    /// - Parameters:
    ///   - title: screen title
    ///   - imageURL: image URL
    func update(title: String, imageURL: URL?)
    
}
