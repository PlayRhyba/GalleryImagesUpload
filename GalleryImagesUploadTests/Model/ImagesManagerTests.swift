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
    
    private let testImages = makeTestImageObjects()
    
    override func spec() {
        describe("ImagesManager") {
            var sut: ImagesManager!
            var dataLoader: DataLoaderStub!
            var imageDatabase: ImageDatabaseStub!
            var imageDataProcessor: ImageDataProcessorStub!
            
            beforeEach {
                dataLoader = DataLoaderStub()
                imageDatabase = ImageDatabaseStub()
                imageDataProcessor = ImageDataProcessorStub()
                
                sut = ImagesManager(dataLoader: dataLoader,
                                    imageDatabase: imageDatabase,
                                    imageDataProcessor: imageDataProcessor)
            }
            
            context("upload image") {
                let originalData = "original".data(using: .utf8)!
                let previewData = "preview".data(using: .utf8)!
                let originalDataURL = URL(string: "https://firebase.com/original")!
                let previewDataURL = URL(string: "https://firebase.com/preview")!
                
                beforeEach {
                    imageDataProcessor.makeDataStub = { _ in (originalData, previewData) }
                }
                
                it("should upload correct data to storage") {
                    var uploadedOriginalData: Data?
                    var uploadedPreviewData: Data?
                    
                    dataLoader.uploadStub = { data, path in
                        switch path {
                        case let p where p.contains("original"):
                            uploadedOriginalData = data
                            
                            return .success(originalDataURL)
                            
                        case let p where p.contains("preview"):
                            uploadedPreviewData = data
                            
                            return .success(previewDataURL)
                            
                        default:
                            return .failure(.generic("failed"))
                        }
                    }
                    
                    sut.upload(image: UIImage()) { result in
                        expect(result.isSuccess).to(beTrue())
                        expect(uploadedOriginalData).to(equal(originalData))
                        expect(uploadedPreviewData).to(equal(previewData))
                    }
                }
                
                it("should add correct image object to database") {
                    dataLoader.uploadStub = { _, path in
                        switch path {
                        case let p where p.contains("original"):
                            return .success(originalDataURL)
                            
                        case let p where p.contains("preview"):
                            return .success(previewDataURL)
                            
                        default:
                            return .failure(.generic("failed"))
                        }
                    }
                    
                    var addedImages: [Image]?
                    
                    imageDatabase.addStub = { images in
                        addedImages = images
                        
                        return .success(images)
                    }
                    
                    sut.upload(image: UIImage()) { result in
                        expect(result.isSuccess).to(beTrue())
                        
                        expect(addedImages?.first?.uuid).toNot(beEmpty())
                        expect(addedImages?.first?.original).to(equal(originalDataURL))
                        expect(addedImages?.first?.preview).to(equal(previewDataURL))
                    }
                }
            }
            
            context("fetch images") {
                it("should just delegate fetching to image database") {                    
                    imageDatabase.fetchStub = {
                        return .success(self.testImages)
                    }
                    
                    sut.fetchImages { result in
                        expect(result.isSuccess).to(beTrue())
                        expect(result.value).to(equal(self.testImages))
                    }
                }
            }
            
            context("delete image") {
                let imageToDelete = self.testImages.first!
                
                it("should remove data with correct paths from storage") {
                    var originalImagePath: String?
                    var previewImagePath: String?
                    
                    dataLoader.deleteStub = { path in
                        switch path {
                        case let p where p.contains("original"):
                            originalImagePath = path
                            
                            return .success(())
                            
                        case let p where p.contains("preview"):
                            previewImagePath = path
                            
                            return .success(())
                            
                        default:
                            return .failure(.generic("failed"))
                        }
                    }
                    
                    sut.delete(image: imageToDelete) { result in
                        expect(result.isSuccess).to(beTrue())
                        expect(originalImagePath).to(contain(imageToDelete.uuid))
                        expect(previewImagePath).to(contain(imageToDelete.uuid))
                    }
                }
                
                it("should delete correct image object from the database") {
                    dataLoader.deleteStub = { _ in .success(()) }
                    
                    var removedImage: Image?
                    
                    imageDatabase.deleteStub = { image in
                        removedImage = image
                        
                        return .success([])
                    }
                    
                    sut.delete(image: imageToDelete) { result in
                        expect(result.isSuccess).to(beTrue())
                        expect(removedImage).to(equal(imageToDelete))
                    }
                }
            }
        }
    }
    
}
