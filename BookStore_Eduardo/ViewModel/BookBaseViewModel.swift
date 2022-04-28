//
//  BookBaseViewModel.swift
//  BookStore_Eduardo
//
//  Created by eduardofilho on 29/04/22.
//

import Foundation

class BookBaseViewModel: BaseViewModelProtocol {
    var title: String {
        get {
            return ""
        }
    }
    static let BooksKey = "Books"
    
    var allFavoriteBookIds: [String] {
        get {
            let ids: [String]? = PersistenceWrapper.shared.get(id: BookListViewModel.BooksKey)
            return ids ?? []
        }
        set {
            PersistenceWrapper.shared.add(object: newValue, id: BookListViewModel.BooksKey)
        }
    }
}
