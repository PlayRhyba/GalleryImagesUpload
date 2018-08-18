//
//  OperationResultTests.swift
//  GalleryImagesUploadTests
//
//  Created by Alexander Snegursky on 18/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Quick
import Nimble

@testable import GalleryImagesUpload

final class OperationResultTests: QuickSpec {
    
    private enum TestError: Error {
        
        case test
        
    }
    
    override func spec() {
        describe("OperationResult") {
            var sut: OperationResult<String, TestError>!
            
            context("Computed properties") {
                context("success") {
                    let expectedValue = "Well done!"
                    
                    beforeEach {
                        sut = .success(expectedValue)
                    }
                    
                    it("should return correct value for isSuccess property") {
                        expect(sut.isSuccess).to(beTrue())
                    }
                    
                    it("should return correct value for isFailure property") {
                        expect(sut.isFailure).to(beFalse())
                    }
                    
                    it("should return correct value for value property") {
                        expect(sut.value).to(equal(expectedValue))
                    }
                }
                
                context("failure") {
                    beforeEach {
                        sut = .failure(.test)
                    }
                    
                    it("should return correct value for isSuccess property") {
                        expect(sut.isSuccess).to(beFalse())
                    }
                    
                    it("should return correct value for isFailure property") {
                        expect(sut.isFailure).to(beTrue())
                    }
                    
                    it("should return correct value for value property") {
                        expect(sut.value).to(beNil())
                    }
                }
            }
        }
    }
    
}
