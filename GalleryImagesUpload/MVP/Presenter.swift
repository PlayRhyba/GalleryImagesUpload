//
//  Presenter.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import os.log

protocol PresenterProtocol: class {
    
    /// Initialization
    func initialization()
    
    /// Deinitialization
    func deinitialization()
    
    ///  Attach view to presenter
    ///
    ///  - parameter view: view
    func attachView(_ view: ViewProtocol)
    
    ///  View has been attached
    func viewDidAttach()
    
    /// Detach view
    func detachView()
    
    ///  View has been detached
    func viewDidDetach()
    
}

// MARK: Default implementations

extension PresenterProtocol {
    
    func initialization() {}
    
    func deinitialization() {}
    
    func attachView(_ view: ViewProtocol) {}
    
    func viewDidAttach() {}
    
    func detachView() {}
    
    func viewDidDetach() {}
    
}

class Presenter: PresenterProtocol {
    
    weak var view: ViewProtocol?
    
    // MARK: PresenterProtocol
    
    func initialization() {
        os_log("PRESENTER ATTACHED (%@)", "\(type(of: self))")
    }
    
    func deinitialization() {
        os_log("PRESENTER DETACHED (%@)", "\(type(of: self))")
    }
    
    func attachView(_ view: ViewProtocol) {
        self.view = view
        viewDidAttach()
    }
    
    func viewDidAttach() {}
    
    func detachView() {
        view = nil
        viewDidDetach()
    }
    
    func viewDidDetach() {}
    
}
