//
//  ScreenView.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import SVProgressHUD

protocol HUDDisplayable {
    
    /// Show HUD
    func showHUD()
    
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

protocol ScreenViewProtocol: ViewProtocol, HUDDisplayable {}

extension ScreenViewProtocol {
    
    func showHUD() {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
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
