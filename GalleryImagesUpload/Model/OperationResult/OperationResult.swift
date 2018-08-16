//
//  OperationResult.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

/// Operation result's representation
///
/// - success: result with content
/// - failure: failure with error
enum OperationResult<Value, Error: Swift.Error> {
    
    case success(Value)
    case failure(Error)
    
    /// Successfull response
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
            
        case .failure:
            return false
        }
    }
    
    /// Alias for isSuccess negation
    var isFailure: Bool {
        return !isSuccess
    }
    
    /// Attempt to get value
    var value: Value? {
        switch self {
        case .success(let value):
            return value
            
        case .failure:
            return nil
        }
    }
    
}
