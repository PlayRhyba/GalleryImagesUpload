//
//  ScreenView.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import SVProgressHUD

protocol ScreenViewProtocol: ViewProtocol {
    
    /// Show HUD
    func showHUD(status: String?)
    
    /// Show progress
    ///
    /// - Parameter progress: progress
    func showHUD(progress: Float)
    
    /// Show error
    ///
    /// - Parameter message: message
    func show(errorMessage: String?)
    
    /// Dismiss HUD
    func dismissHUD()
    
}

extension ScreenViewProtocol {
    
    func showHUD(status: String? = nil) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: status)
    }
    
    func showHUD(progress: Float) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.showProgress(progress)
    }
    
    func show(errorMessage: String?) {
        SVProgressHUD.showError(withStatus: errorMessage)
    }
    
    func dismissHUD() {
        SVProgressHUD.dismiss()
    }
    
}
