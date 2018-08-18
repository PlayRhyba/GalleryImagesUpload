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
                
                it("should contain images manager") {
                    let dataLoader = container?.resolve(ImagesManagerProtocol.self)
                    
                    expect(dataLoader).toNot(beNil())
                }
                
                it("should contain Gallery screen presenter") {
                    let dataLoader = container?.resolve(GalleryPresenterProtocol.self)
                    
                    expect(dataLoader).toNot(beNil())
                }
                
                it("should contain Preview screen presenter") {
                    let dataLoader = container?.resolve(PreviewPresenterProtocol.self)
                    
                    expect(dataLoader).toNot(beNil())
                }
            }
        }
    }
    
}
