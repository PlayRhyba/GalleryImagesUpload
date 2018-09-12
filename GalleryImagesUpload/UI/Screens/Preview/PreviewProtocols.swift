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
    var images: [Image]? { get set }
    
    /// Current displayed image index
    var index: Int { get set }
    
    /// Present next image
    func presentNext()
    
    /// Present previous image
    func presentPrevious()
    
}

protocol PreviewViewProtocol: ScreenViewProtocol {
    
    /// Update screen's contents
    ///
    /// - Parameters:
    ///   - title: screen title
    ///   - imageURL: image URL
    func update(title: String, imageURL: URL?)
    
}
