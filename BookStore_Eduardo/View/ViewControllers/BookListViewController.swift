//
//  ViewController.swift
//  BookStore_Eduardo
//
//  Created by eduardofilho on 27/04/22.
//

import UIKit
import Alamofire

class BookListViewController: BookBaseViewController {
    
    private var viewModel: BookListViewModel {
        return baseViewModel as! BookListViewModel
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = ((self.view.frame.width/2) - BookListViewController.defaultMargin * 2)
        let itemAspectedRationHeight = itemWidth * BookListViewController.ImageRatioMultiplyer
        layout.itemSize = .init(width: itemWidth,
                                height: itemAspectedRationHeight)
        layout.minimumLineSpacing = BookListViewController.defaultMargin
        layout.sectionInset = UIEdgeInsets.init(top: BookListViewController.defaultMargin,
                                                left: BookListViewController.defaultMargin,
                                                bottom: BookListViewController.defaultMargin,
                                                right: BookListViewController.defaultMargin)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "bookIdentifier")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterButton()
    }
    
    override func viewHierarchy() {
        super.viewHierarchy()
        view.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    func insertItems() {
        DispatchQueue.main.async {
            let numberOfItemsOnCollection = self.collectionView.numberOfItems(inSection: 0)
            var indexPaths = [IndexPath]()
            for i in numberOfItemsOnCollection ..< self.viewModel.numberOfItems {
                indexPaths.append(.init(row: i, section: 0))
            }
            self.collectionView.insertItems(at: indexPaths)
        }
    }
    
    func removeItem(index: Int) {
        DispatchQueue.main.async {
            self.collectionView.deleteItems(at: [.init(row: index, section: 0)])
        }
    }
    
    func updateCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        viewModel.updateItems { [weak self] in
            self?.insertItems()
        }
    }
    
    func setupFilterButton() {
        let config = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "line.3.horizontal.decrease.circle", withConfiguration: config)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(filter))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func filter() {
        viewModel.isFiltering = !viewModel.isFiltering
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem?.isSelected = self.viewModel.isFiltering
        }
        updateCollectionView()
    }
}

extension BookListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookIdentifier",
                                                            for: indexPath) as? BookCollectionViewCell else {
            return UICollectionViewCell()
        }
        let index = indexPath.row
        cell.set(index: index)
        viewModel.imageFor(index: index, completion: cell.setImage())
        
        return cell
    }
}

extension BookListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfItems - 1, !viewModel.isLoading, !viewModel.isFiltering {
            viewModel.fetchItems()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.nextViewController(navigationViewController: self.navigationController, index: indexPath.row)
    }
}

extension BookListViewController: BookListViewControllerDelegate {
    
    func shouldInsertItems() {
        self.insertItems()
    }
    
    func didUnfavorite(index: Int) {
        self.removeItem(index: index)
    }
    
    func shouldShow(error: Error) {
        self.show(error: error)
    }
}
