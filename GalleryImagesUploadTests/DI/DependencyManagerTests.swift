//
//  DependencyManagerTests.swift
//  GalleryImagesUploadTests
//
//  Created by Alexander Snegursky on 18/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Quick
import Nimble
import Swinject

@testable import GalleryImagesUpload

final class DependencyManagerTests: QuickSpec {
    
    override func spec() {
        describe("DependencyManager") {
            var container: Container?
            
            context("Dependencies availability") {
                beforeEach {
                    container = DependencyManager.makeContainer()
                }
                
                it("should contain data loader") {
                    let dataLoader = container?.resolve(DataLoaderProtocol.self)
                    
                    expect(dataLoader).toNot(beNil())
                }
                
                it("should contain image database") {
                    let imageDatabase = container?.resolve(ImageDatabaseProtocol.self)
                    
                    expect(imageDatabase).toNot(beNil())
                }
                
                it("should contain image data processor") {
                    let imageDataProcessor = container?.resolve(ImageDataProcessorProtocol.self)
                    
                    expect(imageDataProcessor).toNot(beNil())
                }
                
                it("should contain images manager") {
                    let imagesManager = container?.resolve(ImagesManagerProtocol.self)
                    
                    expect(imagesManager).toNot(beNil())
                }
                
                it("should contain Gallery screen presenter") {
                    let galleryPresenter = container?.resolve(GalleryPresenterProtocol.self)
                    
                    expect(galleryPresenter).toNot(beNil())
                }
                
                it("should contain Preview screen presenter") {
                    let previewPresenter = container?.resolve(PreviewPresenterProtocol.self)
                    
                    expect(previewPresenter).toNot(beNil())
                }
            }
        }
    }
    
}
