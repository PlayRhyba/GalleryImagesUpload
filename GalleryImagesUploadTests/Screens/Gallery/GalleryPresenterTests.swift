//
//  GalleryPresenterTests.swift
//  GalleryImagesUploadTests
//
//  Created by Alexander Snegursky on 18/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Quick
import Nimble

@testable import GalleryImagesUpload

final class GalleryPresenterTests: QuickSpec {
    
    private let testImages = makeTestImageObjects()
    private let testImage = makeTestImage()
    
    override func spec() {
        describe("GalleryPresenter") {
            var sut: GalleryPresenter!
            var imagesManager: ImagesManagerStub!
            var view: GalleryViewSpy!
            
            beforeEach {
                imagesManager = ImagesManagerStub()
                view = GalleryViewSpy()
                sut = GalleryPresenter(imagesManager: imagesManager)
                
                sut.initialization()
                sut.attachView(view)
            }
            
            context("filling with data") {
                it("should show spinner") {
                    sut.viewDidLoad()
                    
                    expect(view.showHUDInvoked).to(beTrue())
                }
                
                it("should fetch images") {
                    var fetchImagesInvoked = false
                    
                    imagesManager.fetchStub = {
                        fetchImagesInvoked = true
                        
                        return .success([])
                    }
                    
                    sut.viewDidLoad()
                    
                    expect(fetchImagesInvoked).to(beTrue())
                }
                
                it("should hide spinner") {
                    imagesManager.fetchStub = { .success([]) }
                    
                    sut.viewDidLoad()
                    
                    expect(view.dismissHUDInvoked).to(beTrue())
                }
                
                it("should reload view's data") {
                    imagesManager.fetchStub = { .success([]) }
                    
                    sut.viewDidLoad()
                    
                    expect(view.reloadDataInvoked).to(beTrue())
                }
                
                it("should show placeholder if fetched data is empty") {
                    imagesManager.fetchStub = { .success([]) }
                    
                    sut.viewDidLoad()
                    
                    expect(view.updatePlaceholderInvocation.invoked).to(beTrue())
                    expect(view.updatePlaceholderInvocation.isHidden).to(beFalse())
                }
                
                it("should hide placeholder if fetched data is not empty") {
                    imagesManager.fetchStub = { .success(self.testImages) }
                    
                    sut.viewDidLoad()
                    
                    expect(view.updatePlaceholderInvocation.invoked).to(beTrue())
                    expect(view.updatePlaceholderInvocation.isHidden).to(beTrue())
                }
                
                it("should show error with correct message if error occurs") {
                    let expectedMessage = "Error occured"
                    imagesManager.fetchStub = { .failure(.generic(expectedMessage)) }
                    
                    sut.viewDidLoad()
                    
                    expect(view.showErrorMessageInvocation.invoked).to(beTrue())
                    expect(view.showErrorMessageInvocation.errorMessage).to(equal(expectedMessage))
                }
            }
            
            context("adding photo") {
                it("should display image source selection action sheet") {
                    var displayImageSourceSelectionActionSheetInvoked = false
                    
                    view.displayImageSourceSelectionActionSheetStub = {
                        displayImageSourceSelectionActionSheetInvoked = true
                        
                        return .library
                    }
                    
                    sut.add()
                    
                    expect(displayImageSourceSelectionActionSheetInvoked).to(beTrue())
                }
                
                it("should display image picker with correct source") {
                    view.displayImageSourceSelectionActionSheetStub = { .library }
                    
                    var selectedSource: ImageSource?
                    
                    view.displayImagePickerStub = { source in
                        selectedSource = source
                        
                        return UIImage()
                    }
                    
                    sut.add()
                    
                    expect(selectedSource).to(equal(ImageSource.library))
                }
                
                it("should display image picker with correct source") {
                    view.displayImageSourceSelectionActionSheetStub = { .camera }
                    
                    var selectedSource: ImageSource?
                    
                    view.displayImagePickerStub = { source in
                        selectedSource = source
                        
                        return UIImage()
                    }
                    
                    sut.add()
                    
                    expect(selectedSource).to(equal(ImageSource.camera))
                }
                
                it("should show spinner") {
                    view.displayImageSourceSelectionActionSheetStub = { .library }
                    view.displayImagePickerStub = { _ in UIImage() }
                    
                    sut.add()
                    
                    expect(view.showHUDInvoked).to(beTrue())
                }
                
                it("should upload correct image to storage") {
                    var uploadedImage: UIImage?
                    
                    view.displayImageSourceSelectionActionSheetStub = { .library }
                    view.displayImagePickerStub = { _ in self.testImage }
                    
                    imagesManager.uploadStub = { image in
                        uploadedImage = image
                        
                        return .success([])
                    }
                    
                    sut.add()
                    
                    expect(uploadedImage).to(equal(self.testImage))
                }
                
                it("should hide spinner") {
                    view.displayImageSourceSelectionActionSheetStub = { .library }
                    view.displayImagePickerStub = { _ in UIImage() }
                    imagesManager.uploadStub = { _ in .success([]) }
                    
                    sut.add()
                    
                    expect(view.dismissHUDInvoked).to(beTrue())
                }
                
                it("should reload view's data") {
                    view.displayImageSourceSelectionActionSheetStub = { .library }
                    view.displayImagePickerStub = { _ in UIImage() }
                    imagesManager.uploadStub = { _ in .success([]) }
                    
                    sut.add()
                    
                    expect(view.reloadDataInvoked).to(beTrue())
                }
                
                it("should show placeholder if fetched data is empty") {
                    view.displayImageSourceSelectionActionSheetStub = { .library }
                    view.displayImagePickerStub = { _ in UIImage() }
                    imagesManager.uploadStub = { _ in .success([]) }
                    
                    sut.add()
                    
                    expect(view.updatePlaceholderInvocation.invoked).to(beTrue())
                    expect(view.updatePlaceholderInvocation.isHidden).to(beFalse())
                }
                
                it("should hide placeholder if fetched data is not empty") {
                    view.displayImageSourceSelectionActionSheetStub = { .library }
                    view.displayImagePickerStub = { _ in UIImage() }
                    imagesManager.uploadStub = { _ in .success(self.testImages) }
                    
                    sut.add()
                    
                    expect(view.updatePlaceholderInvocation.invoked).to(beTrue())
                    expect(view.updatePlaceholderInvocation.isHidden).to(beTrue())
                }
                
                it("should show error with correct message if error occurs") {
                    let expectedMessage = "Error occured"
                    
                    view.displayImageSourceSelectionActionSheetStub = { .library }
                    view.displayImagePickerStub = { _ in UIImage() }
                    imagesManager.uploadStub = { _ in .failure(.generic(expectedMessage)) }
                    
                    sut.add()
                    
                    expect(view.showErrorMessageInvocation.invoked).to(beTrue())
                    expect(view.showErrorMessageInvocation.errorMessage).to(equal(expectedMessage))
                }
            }
            
            context("retrieving table cells' presenters") {
                it("should return correct number of cells") {
                    imagesManager.fetchStub = { .success(self.testImages) }
                    let expected = self.testImages.count
                    
                    sut.viewDidLoad()
                    let actual = sut.numberOfCells()
                    
                    expect(actual).to(equal(expected))
                }
                
                it("should return correct set of cell presenters") {
                    imagesManager.fetchStub = { .success(self.testImages) }
                    
                    sut.viewDidLoad()
                    
                    let expected = self.testImages.sorted(by: >)
                    
                    let actual = Array(0..<sut.numberOfCells())
                        .compactMap { sut.cellPresenter(at: IndexPath(row: $0, section: 0))?.image }
                    
                    expect(actual).to(equal(expected))
                }
            }
            
            context("selecting cell") {
                it("should display correct image preview") {
                    imagesManager.fetchStub = { .success(self.testImages) }
                    
                    sut.viewDidLoad()
                    
                    let expected = self.testImages
                        .sorted(by: >)
                        .first
                    
                    sut.selectCell(at: IndexPath(row: 0, section: 0))
                    
                    expect(view.showImageInvocation.image).to(equal(expected))
                }
            }
            
            context("deleting cell") {
                let indexPathToDelete = IndexPath(row: 0, section: 0)
                
                beforeEach {
                    imagesManager.fetchStub = { .success(self.testImages) }
                    
                    sut.viewDidLoad()
                }
                
                it("should display spinner") {
                    sut.deleteCell(at: indexPathToDelete)
                    
                    expect(view.showHUDInvoked).to(beTrue())
                }
                
                it("should delete correct image object from storage") {
                    let expectedImage = sut.cellPresenter(at: indexPathToDelete)?.image
                    var deletedImage: Image?
                    
                    imagesManager.deleteStub = { image in
                        deletedImage = image
                        
                        return .success([])
                    }
                    
                    sut.deleteCell(at: indexPathToDelete)
                    
                    expect(deletedImage).to(equal(expectedImage))
                }
                
                it("should hide spinner") {
                    imagesManager.deleteStub = { _ in return .success([]) }
                    
                    sut.deleteCell(at: indexPathToDelete)
                    
                    expect(view.dismissHUDInvoked).to(beTrue())
                }
                
                it("should reload view's data") {
                    imagesManager.deleteStub = { _ in return .success([]) }
                    
                    sut.deleteCell(at: indexPathToDelete)
                    
                    expect(view.reloadDataInvoked).to(beTrue())
                }
                
                it("should show placeholder if fetched data is empty") {
                    imagesManager.deleteStub = { _ in return .success([]) }
                    
                    sut.deleteCell(at: indexPathToDelete)
                    
                    expect(view.updatePlaceholderInvocation.invoked).to(beTrue())
                    expect(view.updatePlaceholderInvocation.isHidden).to(beFalse())
                }
                
                it("should hide placeholder if fetched data is not empty") {
                    imagesManager.deleteStub = { _ in return .success(self.testImages) }
                    
                    sut.deleteCell(at: indexPathToDelete)
                    
                    expect(view.updatePlaceholderInvocation.invoked).to(beTrue())
                    expect(view.updatePlaceholderInvocation.isHidden).to(beTrue())
                }
                
                it("should show error with correct message if error occurs") {
                    let expectedMessage = "Error occured"
                    
                    imagesManager.deleteStub = { _ in return .failure(.generic(expectedMessage)) }
                    
                    sut.deleteCell(at: indexPathToDelete)
                    
                    expect(view.showErrorMessageInvocation.invoked).to(beTrue())
                    expect(view.showErrorMessageInvocation.errorMessage).to(equal(expectedMessage))
                }
            }
        }
    }
    
}
