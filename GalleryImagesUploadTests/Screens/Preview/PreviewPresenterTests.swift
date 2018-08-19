//
//  PreviewPresenterTests.swift
//  GalleryImagesUploadTests
//
//  Created by Alexander Snegursky on 19/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Quick
import Nimble

@testable import GalleryImagesUpload

final class PreviewPresenterTests: QuickSpec {
    
    private let testImageObject = makeTestImageObjects().first!
    
    override func spec() {
        describe("PreviewPresenter") {
            var sut: PreviewPresenter!
            var view: PreviewViewSpy!
            
            beforeEach {
                view = PreviewViewSpy()
                sut = PreviewPresenter()
                
                sut.initialization()
                sut.attachView(view)
            }
            
            context("filling with data") {
                beforeEach {
                    sut.image = self.testImageObject
                    
                    sut.viewDidLoad()
                }
                
                it("should update view with correct title") {
                    let expected = DateFormatter.displaying.string(from: self.testImageObject.date)
                    
                    expect(view.updateInvocation.title).to(equal(expected))
                }
                
                it("should update view with correct original image URL") {
                    let expected = self.testImageObject.original
                    
                    expect(view.updateInvocation.imageURL).to(equal(expected))
                }
            }
        }
    }
    
}
