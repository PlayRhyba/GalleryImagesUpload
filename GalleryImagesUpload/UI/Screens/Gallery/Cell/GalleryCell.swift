//
//  GalleryCell.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 16/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit
import AlamofireImage

final class GalleryCell: BaseTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    
    // MARK: Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImage.image = nil
    }
    
}

// MARK: GalleryCellViewProtocol

extension GalleryCell: GalleryCellViewProtocol {
    
    func update(title: String?, previewURL: URL?) {
        titleLabel.text = title
        
        if let previewURL = previewURL {
            previewImage.af_setImage(withURL: previewURL)
        }
    }
    
}
