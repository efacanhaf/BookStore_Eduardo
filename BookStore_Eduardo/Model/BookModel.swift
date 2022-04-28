//
//  BookModel.swift
//  BookStore_Eduardo
//
//  Created by eduardofilho on 27/04/22.
//

import Foundation

struct BookModelResult: Decodable {
    let items: [BookModel]
}

struct BookModel: Decodable {
    let id: String
    let volumeInfo: VolumeInfoModel
    let saleInfo: SaleInfoModel
}

struct VolumeInfoModel: Decodable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
    
}

struct ImageLinks: Decodable {
    let thumbnail: String?
}

struct SaleInfoModel: Decodable {
    let buyLink: URL?
}

extension BookModel: Equatable {
    static func == (lhs: BookModel, rhs: BookModel) -> Bool {
        return lhs.id == rhs.id
    }
}
