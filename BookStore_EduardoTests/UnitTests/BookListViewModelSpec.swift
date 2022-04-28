//
//  BookListViewModelTests.swift
//  BookStore_EduardoTests
//
//  Created by eduardofilho on 02/05/22.
//

import Quick
import Nimble
@testable import BookStore_Eduardo

class BookListViewModelSpec: QuickSpec {
    
    override func spec() {
        var viewModel: BookListViewModel!
        describe("A list of books") {
            context("Can be filled with a valid JSON") {
                afterEach {
                    viewModel = nil
                }
                beforeEach {
                    viewModel = BookListViewModel(api: self)
                    viewModel.fetchItems()
                }
                it("Fetch Items") {
                    viewModel.fetchItems()
                    expect(viewModel.numberOfItems).to(beGreaterThan(0))
                }
                
                it("Number of items in the list") {
                    expect(viewModel.numberOfItems).to(equal(20))
                }
                
                it("UIImage retrivier") {
                    viewModel.imageFor(index: 0) { index, image in
                        expect(index).to(equal(0))
                        expect(image).toNot(beNil())
                    }
                }
            }
            
            context("Is filtering favorites") {
                afterEach {
                    viewModel = nil
                    PersistenceWrapper.shared.add(object: [String](), id: BookBaseViewModel.BooksKey)
                }
                beforeEach {
                    viewModel = BookListViewModel(api: self)
                    viewModel.fetchItems()
                    let ids = ["x6qjAwAAQBAJ", "1jLPDwAAQBAJ"]
                    PersistenceWrapper.shared.add(object: ids, id: BookBaseViewModel.BooksKey)
                    viewModel.isFiltering = true
                }
                it("Number of items in the favourite list and get the missim item") {
                    viewModel.updateItems {
                        expect(viewModel.numberOfItems).to(equal(2))
                    }
                }
            }
        }
    }
}

extension BookListViewModelSpec: BookAPIProviderProtocol {
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
