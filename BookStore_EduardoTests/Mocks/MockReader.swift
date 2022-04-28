//
//  MockReader.swift
//  BookStore_EduardoTests
//
//  Created by eduardofilho on 02/05/22.
//

import Foundation
import UIKit
@testable import BookStore_Eduardo

class MockReader {
    
    static func getImageData() -> Data? {
        return UIImage.init(named: "BookImageMock.jpeg",
                            in: Bundle(for: MockReader.self),
                            with: nil)?.jpegData(compressionQuality: 1.0)
    }
    
    static func getBookListMock() -> BookModelResult? {
        return loadJson(filename: "BookListMock")
    }
    
    static func getBookMock() -> BookModel? {
        return loadJson(filename: "BookMock")
    }
    
    private static func loadJson <T: Decodable>(filename fileName: String) -> T? {
        if let url = Bundle(for: MockReader.self).url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                return jsonData
            } catch { }
        }
        return nil
    }
}
