//
//  AppDelegate.swift
//  GalleryImagesUpload
//
//  Created by Alexander Snegursky on 15/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import UIKit
import SwinjectStoryboard

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let container = DependencyManager.makeContainer()
    
    // MARK: Application Lifecle
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupInitialView()
        
        return true
    }
    
}

// MARK: Private

private extension AppDelegate {
    
    func setupInitialView() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        window.makeKeyAndVisible()
        self.window = window
        
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
        window.rootViewController = storyboard.instantiateInitialViewController()
    }
    
}

