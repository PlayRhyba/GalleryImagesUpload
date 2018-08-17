//
//  PreviewViewController.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 17/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit
import AlamofireImage

final class PreviewViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
}

// MARK: PreviewViewProtocol

extension PreviewViewController: PreviewViewProtocol {
    
    func update(title: String, imageURL: URL?) {
        self.title = title
        
        if let imageURL = imageURL {
            activityIndicator.startAnimating()
            
            imageView.af_setImage(withURL: imageURL) { [weak self] _ in
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
}
