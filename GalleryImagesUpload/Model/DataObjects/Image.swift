//
//  Image.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation

/// Stored image's representation
struct Image: Codable {
    
    /// UUID
    let uuid: String
    
    /// Creation date
    let date: Date
    
    /// URL to original image
    var original: URL?
    
    /// URL to preview image
    var preview: URL?
    
}
