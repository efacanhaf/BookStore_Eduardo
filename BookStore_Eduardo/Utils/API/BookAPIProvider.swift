//
//  BookAPIProvider.swift
//  BookStore_Eduardo
//
//  Created by eduardofilho on 27/04/22.
//

import Foundation
import Alamofire

class BookAPIProvider: BookAPIProviderProtocol {
    private let api = Session()
    private let baseUrl = "https://www.googleapis.com/books/v1/volumes"
    private let imagesCache = NSCache<NSString, NSData>()
    
    enum EndPoint: String {
        case all = "?q=ios"
        case id = "/"
    }
    
    func getBooks(startIndex: Int, completion: @escaping (Result<BookModelResult, Error>) -> Void) {
        self.request(url: baseUrl + EndPoint.all.rawValue,
                     parameters: ["maxResults" : 20,
                                  "startIndex" : startIndex],
                     completion: completion)
            
    }
    
    func getBook(id: String, completion: @escaping (Result<BookModel, Error>) -> Void) {
        let url = baseUrl + EndPoint.id.rawValue + id
        self.request(url: url, completion: completion)
    }
    
    func getImage(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let nsUrl = NSString(string: url)
        if let data = imagesCache.object(forKey: nsUrl) {
            completion(.success(Data(data)))
        } else {
            self.request(url: url) { (result: Result<Data, Error>) in
                switch result {
                case .success(let data):
                    self.imagesCache.setObject(NSData(data: data), forKey: nsUrl)
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func request <T: Decodable>(url: String,
                                        method: HTTPMethod = .get,
                                        parameters: [String : Any]? = nil,
                                        completion: @escaping (Result<T, Error>) -> Void) {
        api.request(url, parameters: parameters).responseDecodable { (response: DataResponse<T, AFError>) in
            switch response.result {
            case .success(let model):
                completion(.success(model))
            case .failure(let err):
                completion(.failure(err as Error))
            }
        }
    }
    
    private func request(url: String,
                         method: HTTPMethod = .get,
                         parameters: [String : Any]? = nil,
                         completion: @escaping (Result<Data, Error>) -> Void) {
        api.request(url).responseData { (response: AFDataResponse<Data>) in
            switch response.result {
            case .success(let model):
                completion(.success(model))
            case .failure(let err):
                completion(.failure(err as Error))
            }
        }
    }
}
