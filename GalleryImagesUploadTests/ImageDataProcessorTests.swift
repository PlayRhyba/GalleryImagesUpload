//
//  ImageDataProcessorTests.swift
//  GalleryImagesUploadTests
//
//  Created by Alexander Snegursky on 18/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Quick
import Nimble

@testable import GalleryImagesUpload

final class ImageDataProcessorTests: QuickSpec {
    
    private let testImage = makeTestImage()
    
    override func spec() {
        describe("ImageDataProcessor") {
            var sut: ImageDataProcessor!
            
            beforeEach {
                sut = ImageDataProcessor()
            }
            
            context("data preparation") {
                var originalData: Data?
                var previewData: Data?
                
                beforeEach {
                    waitUntil { done in
                        sut.makeData(from: self.testImage) { original, preview in
                            originalData = original
                            previewData = preview
                            
                            done()
                        }
                    }
                }
                
                it("should generate data for original image") {
                    expect(originalData).toNot(beNil())
                }
                
                it("should generate data for preview image") {
                    expect(previewData).toNot(beNil())
                }
                
                it("preview image data size should be less then original one") {
                    let originalSize = originalData?.count ?? 0
                    let previewSize = previewData?.count ?? 0
                    
                    expect(previewSize).to(beLessThan(originalSize))
                }
            }
        }
    }
    
}
