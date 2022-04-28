//
//  BookViewSpec.swift
//  BookStore_EduardoTests
//
//  Created by eduardofilho on 02/05/22.
//

import Quick
import Nimble
import Nimble_Snapshots
@testable import BookStore_Eduardo

class BookViewSpec: QuickSpec {
    override func spec() {
        var viewController: BookViewController!
        var viewModel: BookViewModel!
        
        describe("A Book list screen") {
            context("Can be filled with a list of Book") {
                afterEach {
                    viewController = nil
                    viewModel = nil
                    PersistenceWrapper.shared.add(object: [String](), id: BookBaseViewModel.BooksKey)
                }
                beforeEach {
                    guard let model = MockReader.getBookMock(), let imageData = MockReader.getImageData() else {
                        fail("Expect a loaded model")
                        return
                    }
                    let image = UIImage(data: imageData)
                    viewModel = BookViewModel(bookModel: model, image: image, delegate: self)
                    viewController = BookViewController(viewModel: viewModel)
                }
                
                it("screen fullfilled") {
                    expect(viewController).toEventually(haveValidSnapshot())
                }
                
                it("Check favorite") {
                    viewModel.isFavorited = true
                    expect(viewController).toEventually(haveValidSnapshot())
                }
                
                it("Check unfavorite") {
                    viewModel.isFavorited = false
                    expect(viewController).toEventually(haveValidSnapshot())
                }
            }
        }
    }
}

extension BookViewSpec: BookListViewModelDelegate {
    func didUnfavorite(book: BookModel) {
        
    }
}
