//
//  PreviewViewSpy.swift
//  GalleryImagesUploadTests
//
//  Created by Alexander Snegursky on 19/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation

@testable import GalleryImagesUpload

final class PreviewViewSpy {
    
    var updateInvocation: (invoked: Bool, title: String?, imageURL: URL?) = (false, nil, nil)
    
}

// MARK: PreviewViewProtocol

extension PreviewViewSpy: PreviewViewProtocol {
    
    func update(title: String, imageURL: URL?) {
        updateInvocation = (true, title, imageURL)
    }
    
}
