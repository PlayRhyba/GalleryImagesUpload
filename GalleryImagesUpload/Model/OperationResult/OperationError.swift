//
//  OperationError.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

/// Error's representation
///
/// - loading: data uploading/downloading error
/// - serialization: data serialization/deserialization error
enum OperationError: Error {
    
    case loading(String)
    case serialization(String)
    
}
