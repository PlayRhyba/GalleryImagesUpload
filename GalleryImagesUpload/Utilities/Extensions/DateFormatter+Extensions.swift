//
//  DateFormatter+Extensions.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 17/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static var displaying: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        return formatter
    }
    
}
