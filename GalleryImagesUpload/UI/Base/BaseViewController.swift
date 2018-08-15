//
//  BaseViewController.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, ScreenViewProtocol {
    
    var presenter: ScreenPresenterProtocol? {
        didSet {
            if let presenter = presenter {
                presenter.attachView(self)
            } else {
                presenter?.detachView()
            }
        }
    }
    
    // MARK: Deinitialization
    
    deinit {
        presenter?.detachView()
        presenter?.deinitialization()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.attachView(self)
        presenter?.initialization()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.viewDidDisappear()
    }
    
}
