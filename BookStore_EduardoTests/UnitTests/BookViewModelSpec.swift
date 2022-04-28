//
//  BookViewModelSpec.swift
//  BookStore_EduardoTests
//
//  Created by eduardofilho on 02/05/22.
//

import Quick
import Nimble
@testable import BookStore_Eduardo

class BookViewModelSpec: QuickSpec {
    
    override func spec() {
        var viewModel: BookViewModel!
        describe("A Book") {
            context("Book viewModel loaded from a valid JSON") {
                afterEach {
                    viewModel = nil
                    PersistenceWrapper.shared.add(object: [String](), id: BookBaseViewModel.BooksKey)
                }
                beforeEach {
                    guard let model = MockReader.getBookMock() else {
                        fail("Expect a loaded model")
                        return 
                    }
                    let image = UIImage(named: "BookImageMock")
                    viewModel = BookViewModel(bookModel: model, image: image, delegate: self)
                }
                it("Checking description no nil") {
                    expect(viewModel.description).notTo(beNil())
                }
                
                it("Checking authors to not be empty") {
                    expect(viewModel.authors).notTo(beEmpty())
                }
                it("Check favorite") {
                    viewModel.isFavorited = true
                    expect(viewModel.allFavoriteBookIds).notTo(beEmpty())
                }
                
                it("Check unfavorite") {
                    viewModel.isFavorited = false
                    expect(viewModel.allFavoriteBookIds).to(beEmpty())
                }
            }
        }
    }
}

extension BookViewModelSpec: BookListViewModelDelegate {
    func didUnfavorite(book: BookModel) { }
}
