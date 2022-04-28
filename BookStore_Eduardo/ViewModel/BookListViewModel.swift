//
//  BookListViewModel.swift
//  BookStore_Eduardo
//
//  Created by eduardofilho on 27/04/22.
//

import Foundation
import Alamofire

class BookListViewModel: BookBaseViewModel {
    private let api: BookAPIProviderProtocol
    override var title: String {
        get {
            return String(localized: "iOSBooks")
        }
    }
    
    private var models = [BookModel]()
    private var items = [BookModel]()
    
    weak var delegate: BookListViewControllerDelegate?
    
    var numberOfItems: Int {
        return items.count
    }
    
    init(api: BookAPIProviderProtocol = BookAPIProvider()) {
        self.api = api
    }
    
    var isLoading = false
    var isFiltering = false {
        didSet {
            if isFiltering {
                items = models.filter { id1 in
                    return self.allFavoriteBookIds.contains(id1.id)
                }
            } else {
                items = models
            }
        }
    }
    
    func fetchItems() {
        self.isLoading = true
        self.api.getBooks(startIndex: self.models.count) { result in
            switch result {
            case .success(let result):
                self.models.append(contentsOf: result.items)
                self.items = self.models
                self.isLoading = false
                self.delegate?.shouldInsertItems()
            case .failure(let error):
                self.isLoading = false
                self.delegate?.shouldShow(error: error)
            }
        }
    }
    
    func imageFor(index: Int, completion: ((Int, UIImage?) -> Void)?) {
        guard let item = itemFor(index: index)?.volumeInfo, let url = item.imageLinks?.thumbnail else {
            completion?(index, nil)
            return
        }
        self.api.getImage(url: url) { result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                completion?(index, image)
            default:
                completion?(index, nil)
                break
            }
        }
    }
    
    func updateItems(completion: @escaping () -> ()) {
        if isFiltering {
            let modelsIds = models.map{ $0.id }
            let missing = Array(Set(allFavoriteBookIds).subtracting(modelsIds))
            
            self.getMissingBooks(missing: missing, completion: completion)
        }
    }
    
    func nextViewController(navigationViewController: UINavigationController?, index: Int) {
        guard let item = itemFor(index: index) else { return }
        self.imageFor(index: index) { _, image in
            let vm = BookViewModel(bookModel: item, image: image, delegate: self)
            let vc = BookViewController(viewModel: vm)
            DispatchQueue.main.async {
                navigationViewController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    private func getMissingBooks(missing: [String], completion: @escaping () -> ()) {
        missing.forEach { id in
            api.getBook(id: id) { [weak self] result in
                try? self?.items.append(result.get())
                completion()
            }
        }
    }
    
    private func itemFor(index: Int) -> BookModel? {
        if items.indices.contains(index) {
            return items[index]
        } else {
            return nil
        }
    }
}

extension BookListViewModel: BookListViewModelDelegate {
    func didUnfavorite(book: BookModel) {
        guard let index = self.items.firstIndex(of: book) else { return }
        self.items.remove(at: index)
        self.delegate?.didUnfavorite(index: index)
    }
}
