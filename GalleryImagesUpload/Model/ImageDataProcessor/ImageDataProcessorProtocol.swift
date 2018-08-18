//
//  ImageDataProcessorProtocol.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 18/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

protocol ImageDataProcessorProtocol {
    
    /// Prepare data for original and preview images
    ///
    /// - Parameters:
    ///   - image: image to process
    ///   - completion: completion handler with original and preview data
    func makeData(from image: UIImage,
                  completion: @escaping (Data?, Data?) -> Void)
    
}


