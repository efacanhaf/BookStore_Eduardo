//
//  BookCollectionViewCell.swift
//  BookStore_Eduardo
//
//  Created by eduardofilho on 27/04/22.
//

import Foundation
import UIKit
import SnapKit

class BookCollectionViewCell: UICollectionViewCell, CodeViewProtocol {
    
    static let Margin: CGFloat = 16
    
    private let imageView = UIImageView()
    private var imageBlock: ((Int, UIImage?) -> Void)?
    private var cellIndex: Int?
    private let cardView = CardView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.viewHierarchy()
        self.setupConstraints()
        self.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        imageBlock = nil
        super.prepareForReuse()
    }
    
    func viewHierarchy() {
        self.addSubview(cardView)
        cardView.addSubview(imageView)
    }
    
    func setupConstraints() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
    }
    
    func set(index: Int) {
        self.cellIndex = index
    }
    
    func setImage() -> ((Int, UIImage?) -> Void)? {
        imageBlock = { [weak self] (index, image) in
            if index == self?.cellIndex {
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
        return imageBlock
    }
}

