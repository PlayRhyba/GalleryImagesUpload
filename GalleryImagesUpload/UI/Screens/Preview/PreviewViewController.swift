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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizers()
    }
    
}

// MARK: Actions

private extension PreviewViewController {
    
    @objc
    func handleSwipeLeft() {
        getPresenter()?.presentNext()
    }
    
    @objc
    func handleSwipeRight() {
        getPresenter()?.presentPrevious()
    }
    
}

// MARK: Private

private extension PreviewViewController {
    
    func getPresenter() -> PreviewPresenterProtocol? {
        return presenter as? PreviewPresenterProtocol
    }
    
    func setupGestureRecognizers() {
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self,
                                                           action: #selector(handleSwipeLeft))
        leftSwipeRecognizer.direction = .left
        
        view.addGestureRecognizer(leftSwipeRecognizer)
        
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self,
                                                            action: #selector(handleSwipeRight))
        rightSwipeRecognizer.direction = .right
        
        
        view.addGestureRecognizer(rightSwipeRecognizer)
    }
    
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
