//
//  GlobalConstants.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 17/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

struct GlobalConstants {
    
    static let maxDownloadingFileSize: Int64 = 2 * 1024 * 1024
    static let maxPreviewImageDimension: CGFloat = 100
    static let jpegCompretionQuality: CGFloat = 0.85
    static let imagesFolder = "images"
    static let originalFileSuffix = "original"
    static let previewFileSuffix = "preview"
    static let imageFileExtension = "jpg"
    static let contentsFileName = "contents.json"
    
}
