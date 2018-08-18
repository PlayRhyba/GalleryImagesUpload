//
//  DataLoaderTests.swift
//  GalleryImagesUploadTests
//
//  Created by Alexander Snegursky on 18/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Quick
import Nimble

@testable import GalleryImagesUpload

final class DataLoaderTests: QuickSpec {
    
    private struct Constants {
        
        static let testBucket = "gs://galleryimagesupload_test"
        static let testFilePath = "test.dat"
        static let testData = "Test data".data(using: .utf8)!
        static let timeout = 15.0
        static let maxDownloadingFileSize: Int64 = 1024
        
    }
    
    override func spec() {
        describe("DataLoader") {
            var sut: DataLoader!
            
            beforeEach {
                sut = DataLoader(bucket: Constants.testBucket)
            }
            
            context("uploading") {
                it("should upload data and return the URL to created file") {
                    waitUntil(timeout: Constants.timeout) { done in
                        sut.upload(data: Constants.testData,
                                   path: Constants.testFilePath,
                                   progress: nil) { result in
                                    expect(result.isSuccess).to(beTrue())
                                    expect(result.value).toNot(beNil())
                                    
                                    done()
                        }
                    }
                }
            }
            
            context("donwloading") {
                beforeEach {
                    waitUntil(timeout: Constants.timeout) { done in
                        sut.upload(data: Constants.testData,
                                   path: Constants.testFilePath,
                                   progress: nil) {
                                    if case .failure(let error) = $0 {
                                        fail(error.localizedDescription)
                                    }
                                    
                                    done()
                        }
                    }
                }
                
                it("should donwload the previously uploaded file") {
                    waitUntil(timeout: Constants.timeout) { done in
                        sut.download(path: Constants.testFilePath,
                                     maxSize: Constants.maxDownloadingFileSize,
                                     progress: nil) { result in
                                        expect(result.isSuccess).to(beTrue())
                                        
                                        let expected = String(data: Constants.testData, encoding: .utf8)
                                        let actual = String(data: result.value ?? Data(), encoding: .utf8)
                                        
                                        expect(actual).to(equal(expected))
                                        
                                        done()
                        }
                    }
                }
            }
            
            context("deleting") {
                beforeEach {
                    waitUntil(timeout: Constants.timeout) { done in
                        sut.upload(data: Constants.testData,
                                   path: Constants.testFilePath,
                                   progress: nil) {
                                    if case .failure(let error) = $0 {
                                        fail(error.localizedDescription)
                                    }
                                    
                                    done()
                        }
                    }
                }
                
                it("should delete the previously uploaded file") {
                    waitUntil(timeout: Constants.timeout) { done in
                        sut.delete(path: Constants.testFilePath) { result in
                            expect(result.isSuccess).to(beTrue())
                            
                            done()
                        }
                    }
                }
            }
        }
    }
    
}
