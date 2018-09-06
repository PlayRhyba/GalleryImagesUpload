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
    @IBOutlet private weak var placeholderLabel: UILabel!
    private var imagePicker: ImagePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizers()
    }
    
}

// MARK: GalleryViewProtocol

extension GalleryViewController: GalleryViewProtocol {
    
    func displayImageSourceSelectionActionSheet(completion: @escaping (ImageSource) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        [UIAlertAction(title: "Library", style: .default, handler: { _ in completion(.library) }),
         UIAlertAction(title: "Camera", style: .default, handler: { _ in completion(.camera) }),
         UIAlertAction(title: "Cancel", style: .cancel)]
            .forEach { alert.addAction($0) }
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(alert, animated: true)
    }
    
    func showDeleteConfirmationAlert(confirmed: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Delete image?",
                                      message: "Are you sure you want to delete selected images?",
                                      preferredStyle: .alert)
        
        [UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in confirmed(false) }),
         UIAlertAction(title: "Delete", style: .destructive, handler: { _ in confirmed(true) })]
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
    
    func updatePlaceholder(isHidden: Bool) {
        placeholderLabel.isHidden = isHidden
    }
    
    func update(state: SelectionState) {
        switch state {
        case .none:
            navigationItem.leftBarButtonItem = nil
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self,
                                                                action: #selector(addButtonClicked))
            
        case .selected(let selected):
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                               target: self,
                                                               action: #selector(cancelButtonClicked))
            
            navigationItem.rightBarButtonItem = selected ? UIBarButtonItem(barButtonSystemItem: .trash,
                                                                           target: self,
                                                                           action: #selector(deleteButtonClicked)) : nil
        }
    }
    
    func show(image: Image) {
        let identifier = PreviewViewController.identifier
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: identifier) as? PreviewViewController else {
            return
        }
        
        (vc.presenter as? PreviewPresenterProtocol)?.image = image
        
        navigationController?.pushViewController(vc, animated: true)
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getPresenter()?.handleSelectionOnCell(at: indexPath)
    }
    
}

// MARK: Actions

private extension GalleryViewController {
    
    @objc
    func addButtonClicked() {
        getPresenter()?.add()
    }
    
    @objc
    func cancelButtonClicked() {
        getPresenter()?.cancel()
    }
    
    @objc
    func deleteButtonClicked() {
        getPresenter()?.delete()
    }
    
    @objc
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: tableView)
        
        guard let indexPath = tableView.indexPathForRow(at: point),
            recognizer.state == .began else { return }
        
        getPresenter()?.handleLongPressOnCell(at: indexPath)
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
    
    func setupGestureRecognizers() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(handleLongPress))
        longPressRecognizer.minimumPressDuration = 1.5
        tableView.addGestureRecognizer(longPressRecognizer)
    }
    
}
