//
//  GalleryViewController.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

final class GalleryViewController: BaseViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var imagePicker: ImagePicker?
    
}

// MARK: GalleryViewProtocol

extension GalleryViewController: GalleryViewProtocol {
    
    func displayImageSourceSelectionActionSheet(completion: @escaping (ImageSource) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        [UIAlertAction(title: "Library", style: .default, handler: { _ in completion(.library) }),
         UIAlertAction(title: "Camera", style: .default, handler: { _ in completion(.camera) }),
         UIAlertAction(title: "Cancel", style: .cancel)]
            .forEach { alert.addAction($0) }
        
        present(alert, animated: true)
    }
    
    func displayImagePicker(source: ImageSource, completion: @escaping (UIImage?) -> Void) {
        imagePicker = ImagePicker(viewController: self,
                                  sourceType: source.asSourceType,
                                  completion: completion)
        imagePicker?.show()
    }
    
}

// MARK: Actions

private extension GalleryViewController {
    
    @IBAction func addButtonClicked() {
        getPresenter()?.add()
    }
    
}

// MARK: Private

private extension ImageSource {
    
    var asSourceType: UIImagePickerControllerSourceType {
        switch self {
        case .library:
            return .photoLibrary
            
        case.camera:
            return .camera
        }
    }
    
}

private extension GalleryViewController {
    
    func getPresenter() -> GalleryPresenterProtocol? {
        return presenter as? GalleryPresenterProtocol
    }
    
}
