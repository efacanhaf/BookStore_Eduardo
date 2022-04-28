//
//  BookViewModel.swift
//  BookStore_Eduardo
//
//  Created by eduardofilho on 28/04/22.
//

import Foundation
import UIKit

class BookViewModel: BookBaseViewModel {
    private let bookModel: BookModel
    
    override var title: String {
        get {
            return bookModel.volumeInfo.title
        }
    }
    
    let image: UIImage?
    
    var description: String {
        return bookModel.volumeInfo.description ?? ""
    }
    
    var authors: String {
        return "por " + (bookModel.volumeInfo.authors?.joined(separator: ", ") ?? "")
    }
    
    var hasBuyLink: Bool {
        return url != nil
    }

    var isFavorited: Bool {
        set {
            var favorites = allFavoriteBookIds
            if newValue {
                favorites.append(bookModel.id)
            } else {
                self.delegate?.didUnfavorite(book: bookModel)
                guard let index = favorites.firstIndex(of: bookModel.id) else { return }
                favorites.remove(at: index)
            }
            allFavoriteBookIds = favorites
        }
        
        get {
            return allFavoriteBookIds.contains { id in
                return id == bookModel.id
            }
        }
    }
    
    private var url: URL? {
        return bookModel.saleInfo.buyLink
    }
    
    weak var delegate: BookListViewModelDelegate?
    
    init(bookModel: BookModel, image: UIImage?, delegate: BookListViewModelDelegate) {
        self.bookModel = bookModel
        self.image = image
        self.delegate = delegate
    }
    
    func buy() {
        guard let url = url else {
            return
        }

        UIApplication.shared.open(url)
    }
}
