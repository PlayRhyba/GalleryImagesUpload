//
//  ScreenPresenter.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

protocol ScreenPresenterProtocol: PresenterProtocol {
    
    /// View has been loaded
    func viewDidLoad()
    
    /// View is about to appear
    func viewWillAppear()
    
    /// View has been appeared
    func viewDidAppear()
    
    /// View is about to disappear
    func viewWillDisappear()
    
    /// View has been disappeared
    func viewDidDisappear()
    
}

class ScreenPresenter: Presenter, ScreenPresenterProtocol {
    
    // MARK: ScreenPresenterProtocol
    
    func viewDidLoad() {}
    
    func viewWillAppear() {}
    
    func viewDidAppear() {}
    
    func viewWillDisappear() {}
    
    func viewDidDisappear() {}
    
}

