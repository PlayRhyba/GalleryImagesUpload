//
//  QuickSpec+TestData.swift
//  GalleryImagesUploadTests
//
//  Created by Alexander Snegursky on 19/08/2018.
//  Copyright © 2018 Alexander Snegursky. All rights reserved.
//

import Quick

@testable import GalleryImagesUpload

private class TestData {}

extension QuickSpec {
    
    static func makeTestImagesData() -> Data {
        let path = Bundle(for: TestData.self).path(forResource: "testData", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        
        return try! Data(contentsOf: url)
    }
    
    static func makeTestImageObjects() -> [Image] {
        let path = Bundle(for: TestData.self).path(forResource: "testData", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try! decoder.decode([Image].self, from: data)
    }
    
    static func makeTestImage() -> UIImage {
        let path = Bundle(for: TestData.self).path(forResource: "testImage", ofType: "jpg")!
        
        return UIImage(contentsOfFile: path)!
    }
    
}
