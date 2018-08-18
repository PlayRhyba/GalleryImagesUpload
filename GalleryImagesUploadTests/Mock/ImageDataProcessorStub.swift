//
//  ImageDataProcessorStub.swift
//  GalleryImagesUploadTests
//
//  Created by Alexander Snegursky on 18/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

@testable import GalleryImagesUpload

final class ImageDataProcessorStub {
    
    typealias MakeDataStub = (UIImage) -> ((original: Data?, preview: Data?))
    
    var makeDataStub: MakeDataStub?
    
}

extension ImageDataProcessorStub: ImageDataProcessorProtocol {
    
    func makeData(from image: UIImage,
                  completion: @escaping (Data?, Data?) -> Void) {
        guard let makeDataStub = makeDataStub else { return }
        
        let data = makeDataStub(image)
        
        completion(data.original, data.preview)
    }
    
}
