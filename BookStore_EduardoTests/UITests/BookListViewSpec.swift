//
//  BookListViewTest.swift
//  BookStore_EduardoTests
//
//  Created by eduardofilho on 02/05/22.
//

import Quick
import Nimble
import Nimble_Snapshots
@testable import BookStore_Eduardo

class BooklistViewSpec: QuickSpec {
    override func spec() {
        var viewController: BookListViewController!
        var viewModel: BookListViewModel!
        
        describe("A Book list screen") {
            context("Can be filled with a list of Book") {
                afterEach {
                    viewController = nil
                    viewModel = nil
                    PersistenceWrapper.shared.add(object: [String](), id: BookBaseViewModel.BooksKey)
                }
                beforeEach {
                    viewModel = BookListViewModel(api: self)
                    viewModel.fetchItems()
                    viewController = BookListViewController(viewModel: viewModel)
                    viewModel.delegate = viewController
                }
                it("screen fullfilled") {
                    expect(viewController).toEventually(haveValidSnapshot(), timeout: .seconds(5))
                }
                
                it("favorites only") {
                    viewModel = BookListViewModel(api: self)
                    viewModel.fetchItems()
                    let ids = ["x6qjAwAAQBAJ", "1jLPDwAAQBAJ"]
                    PersistenceWrapper.shared.add(object: ids, id: BookBaseViewModel.BooksKey)
                    viewModel.isFiltering = true
                    viewController.filter()
                    
                    expect(viewController).toEventually(haveValidSnapshot(), timeout: .seconds(5))
                }
            }
        }
    }
}

extension BooklistViewSpec: BookAPIProviderProtocol {
    func getBook(id: String, completion: @escaping (Result<BookModel, Error>) -> Void) {
        guard let model = MockReader.getBookMock() else { return }
        completion(.success(model))
    }
    
    func getBooks(startIndex: Int, completion: @escaping (Result<BookModelResult, Error>) -> Void) {
        guard let model = MockReader.getBookListMock() else { return }
        completion(.success(model))
    }
    
    func getImage(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let data = MockReader.getImageData() else { return }
        completion(.success(data))
    }
}
