//
//  GalleryViewController.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

final class GalleryViewController: BaseViewController {
    
    private struct LayoutConstants {
        
        static let cellHeight: CGFloat = 70
        
    }
    
    @IBOutlet private weak var tableView: UITableView!
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
                                  sourceType: source.asSourceType) { [weak self] image in
                                    completion(image)
                                    self?.imagePicker = nil
        }
        
        imagePicker?.show()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func show(image: Image) {
        
    }
    
}

// MARK: UITableViewDataSource

extension GalleryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getPresenter()?.numberOfCells() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GalleryCell.identifier, for: indexPath)
        (cell as? GalleryCell)?.presenter = getPresenter()?.cellPresenter(at: indexPath)
        
        return cell
    }
    
}

// MARK: UITableViewDelegate

extension GalleryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LayoutConstants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getPresenter()?.selectCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        getPresenter()?.deleteCell(at: indexPath)
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
