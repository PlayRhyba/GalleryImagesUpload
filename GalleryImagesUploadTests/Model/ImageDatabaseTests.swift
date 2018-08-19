//
//  ImageDatabaseTests.swift
//  GalleryImagesUploadTests
//
//  Created by Alexander Snegursky on 18/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Quick
import Nimble

@testable import GalleryImagesUpload

final class ImageDatabaseTests: QuickSpec {
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()
    
    private let testImagesData = makeTestImagesData()
    
    var testImages: [Image] {
        return try! jsonDecoder.decode([Image].self, from: testImagesData)
    }
    
    override func spec() {
        describe("ImageDatabase") {
            var sut: ImageDatabase!
            var dataLoader: DataLoaderStub!
            
            beforeEach {
                dataLoader = DataLoaderStub()
                sut = ImageDatabase(dataLoader: dataLoader)
            }
            
            context("Fetch") {
                it("should download data and parse them correctly") {
                    dataLoader.downloadStub = { _ in .success(self.testImagesData) }
                    
                    sut.fetch { result in
                        expect(result.isSuccess).to(beTrue())
                        expect(result.value).toNot(beNil())
                    }
                }
            }
            
            context("Add") {
                let newImage: Image = {
                    let date = ISO8601DateFormatter().date(from: "2018-08-18T17:48:48Z")!
                    
                    return Image(uuid: "82D87FA4-3E3C-4131-ABBF-75010D3A6822",
                                 date: date,
                                 original: URL(string: "https://firebasestorage.googleapis.com/original"),
                                 preview: URL(string: "https://firebasestorage.googleapis.com/preview"))
                }()
                
                var expectedImageSet: Set<Image>!
                
                beforeEach {
                    var images = self.testImages
                    images.append(newImage)
                    expectedImageSet = Set<Image>(images)
                    
                    dataLoader.downloadStub = { _ in .success(self.testImagesData) }
                }
                
                it("should download data, add image, encode correctly and upload correct image set back to storage") {
                    var uploadedData: Data?
                    
                    dataLoader.uploadStub = { data, _ in
                        uploadedData = data
                        
                        return .success(URL(string: "https://firebase.com")!)
                    }
                    
                    sut.add(image: newImage) { result in
                        expect(result.isSuccess).to(beTrue())
                        
                        let actualImages = try? self.jsonDecoder.decode([Image].self, from: uploadedData ?? Data())
                        let actualImageSet = Set<Image>(actualImages ?? [])
                        
                        expect(actualImageSet).to(equal(expectedImageSet))
                    }
                }
                
                it("should return the updated image set from storage") {
                    sut.add(image: newImage) { result in
                        expect(result.isSuccess).to(beTrue())
                        
                        let actualImageSet = Set<Image>(result.value ?? [])
                        
                        expect(actualImageSet).to(equal(expectedImageSet))
                    }
                }
            }
            
            context("Delete") {
                var expectedImageSet: Set<Image>!
                var imageToDelete: Image!
                
                beforeEach {
                    var images = self.testImages
                    imageToDelete = images.removeFirst()
                    expectedImageSet = Set<Image>(images)
                    
                    dataLoader.downloadStub = { _ in .success(self.testImagesData) }
                }
                
                it("should download data, delete image and upload correct image set back to storage") {
                    var uploadedData: Data?
                    
                    dataLoader.uploadStub = { data, _ in
                        uploadedData = data
                        
                        return .success(URL(string: "https://firebase.com")!)
                    }
                    
                    sut.delete(image: imageToDelete) { result in
                        expect(result.isSuccess).to(beTrue())
                        
                        let actualImages = try? self.jsonDecoder.decode([Image].self, from: uploadedData ?? Data())
                        let actualImageSet = Set<Image>(actualImages ?? [])
                        
                        expect(actualImageSet).to(equal(expectedImageSet))
                    }
                }
                
                it("should return the updated image set from storage") {
                    sut.delete(image: imageToDelete) { result in
                        expect(result.isSuccess).to(beTrue())
                        
                        let actualImageSet = Set<Image>(result.value ?? [])
                        
                        expect(actualImageSet).to(equal(expectedImageSet))
                    }
                }
            }
        }
    }
    
}
