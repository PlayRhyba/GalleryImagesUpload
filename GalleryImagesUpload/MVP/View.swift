//
//  View.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

protocol ViewProtocol: class {
    
    /// Identifier (type level)
    static var identifier: String { get }
    
    /// Identifier (instance level)
    var identifier: String { get }
    
}

extension ViewProtocol {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var identifier: String {
        return type(of: self).identifier
    }
    
}
