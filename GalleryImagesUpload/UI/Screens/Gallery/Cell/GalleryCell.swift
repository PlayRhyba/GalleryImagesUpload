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
    @IBOutlet weak var checkmarkContainerView: UIView!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    // MARK: Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupAppearance()
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
    
    func update(state: SelectionState) {
        switch state {
        case .none:
            checkmarkContainerView.isHidden = true
            
        case .selected:
            checkmarkContainerView.isHidden = false
            checkmarkImageView.isHidden = false
            
        case .unselected:
            checkmarkContainerView.isHidden = false
            checkmarkImageView.isHidden = true
        }
    }
    
}

// MARK: Private

private extension GalleryCell {
    
    func getPresenter() -> GalleryCellPresenterProtocol? {
        return presenter as? GalleryCellPresenterProtocol
    }
    
    func setupAppearance() {
        checkmarkContainerView.backgroundColor = .clear
        checkmarkContainerView.layer.cornerRadius = checkmarkContainerView.frame.width / 2.0
        checkmarkContainerView.layer.borderWidth = 1.0
        checkmarkContainerView.layer.borderColor = UIColor.black.cgColor
        
        checkmarkImageView.backgroundColor = .green
        checkmarkImageView.layer.cornerRadius = checkmarkImageView.frame.width / 2.0
    }
    
}
