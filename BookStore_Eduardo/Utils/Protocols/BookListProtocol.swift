//
//  BookListViewControllerProtocol.swift
//  BookStore_Eduardo
//
//  Created by eduardofilho on 29/04/22.
//

import Foundation

protocol BookListViewModelDelegate: AnyObject {
    func didUnfavorite(book: BookModel)
}

protocol BookListViewControllerDelegate: AnyObject {
    func shouldInsertItems()
    func didUnfavorite(index: Int)
    func shouldShow(error: Error)
}
