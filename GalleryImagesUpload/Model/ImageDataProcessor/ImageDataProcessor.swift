//
//  ImageDataProcessor.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 18/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

final class ImageDataProcessor {
    
    private struct Constants {
        
        static let maxPreviewImageDimension: CGFloat = 100
        static let jpegCompretionQuality: CGFloat = 0.85
        
    }
    
}

// MARK: ImageDataProcessorProtocol

extension ImageDataProcessor: ImageDataProcessorProtocol {
    
    func makeData(from image: UIImage,
                  completion: @escaping (Data?, Data?) -> Void) {
        DispatchQueue.global().async {
            let previewImage = image.scaled(to: Constants.maxPreviewImageDimension)
            
            let originalImageData = UIImageJPEGRepresentation(image, Constants.jpegCompretionQuality)
            let previewImageData = UIImageJPEGRepresentation(previewImage, Constants.jpegCompretionQuality)
            
            DispatchQueue.main.async {
                completion(originalImageData, previewImageData)
            }
        }
    }
    
}
