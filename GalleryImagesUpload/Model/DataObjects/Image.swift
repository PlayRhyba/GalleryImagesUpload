//
//  Image.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation

struct Image: Codable {
    
    struct URLs: Codable {
        
        var original: URL?
        var preview: URL?
        
    }
    
    let uuid: String
    let date: Date
    let urls: URLs
    
}
