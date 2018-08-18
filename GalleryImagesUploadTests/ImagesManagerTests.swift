//
//  ImagesManagerTests.swift
//  GalleryImagesUploadTests
//
//  Created by Alexander Snegursky on 18/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Quick
import Nimble

@testable import GalleryImagesUpload

final class ImagesManagerTests: QuickSpec {
    
    override func spec() {
        describe("ImagesManager") {
            var sut: ImagesManager!
            var dataLoader: DataLoaderStub!
            
            beforeEach {
                dataLoader = DataLoaderStub()
                sut = ImagesManager(dataLoader: dataLoader)
            }
            
            context("image uploading") {
                
            }
        }
    }
    
}
