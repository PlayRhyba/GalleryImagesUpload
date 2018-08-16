//
//  UIImage+Extensions.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

extension UIImage {
    
    func scaled(to newSize: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: newSize)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in self.draw(in: rect) }
    }
    
    func scaled(to dimension: CGFloat) -> UIImage {
        let newSize: CGSize = {
            let height = size.height
            let width = size.width
            
            if height > width {
                guard height > dimension else { return size }
                
                let ratio = width / height
                
                return CGSize(width: dimension * ratio, height: dimension)
            } else {
                guard width > dimension else { return size }
                
                let ratio = height / width
                
                return CGSize(width: dimension, height: dimension * ratio)
            }
        }()
        
        return scaled(to: newSize)
    }
    
}
