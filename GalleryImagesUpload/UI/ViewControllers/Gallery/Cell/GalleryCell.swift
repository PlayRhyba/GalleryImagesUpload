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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
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

// MARK: Private

private extension GalleryCell {
    
    func configureAppearance() {
        previewImage.layer.borderColor = UIColor.lightGray.cgColor
        previewImage.layer.borderWidth = 1.0
    }
    
}
