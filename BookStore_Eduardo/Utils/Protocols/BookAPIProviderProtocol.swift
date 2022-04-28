//
//  APIProviderProtocol.swift
//  BookStore_Eduardo
//
//  Created by eduardofilho on 27/04/22.
//

import Foundation
import Alamofire

protocol BookAPIProviderProtocol {
    func getBook(id: String, completion: @escaping (Result<BookModel, Error>) -> Void)
    func getBooks(startIndex: Int, completion: @escaping (Result<BookModelResult, Error>) -> Void)
    func getImage(url: String, completion: @escaping (Result<Data, Error>) -> Void)
}
