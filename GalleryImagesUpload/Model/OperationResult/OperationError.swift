//
//  OperationError.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

/// Error's representation
///
/// - generic: generic errors
/// - dataLoader: data loader errors
/// - serialization: data serialization/deserialization error
enum OperationError: Error {
    
    case generic(String)
    case dataLoader(String)
    case serialization(String)
    
}

extension OperationError {
    
    /// Message to display
    var message: String? {
        switch self {
        case .generic(let text):
            return text
            
        case .dataLoader(let text):
            return text
            
        case .serialization(let text):
            return text
        }
    }
    
}
