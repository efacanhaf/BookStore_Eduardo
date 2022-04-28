//
//  CardView.swift
//  BookStore_Eduardo
//
//  Created by eduardofilho on 28/04/22.
//

import Foundation
import UIKit
import SnapKit

class CardView: UIView, CodeViewProtocol {
    static let cornerRadius: CGFloat = 20
    private let contentView: UIView = {
        let cv = UIView()
        cv.clipsToBounds = true
        cv.layer.cornerRadius = CardView.cornerRadius
        return cv
    }()
    
    override func addSubview(_ view: UIView) {
        contentView.addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewHierarchy()
        setupConstraints()
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.hexF0F1F5.cgColor
        self.layer.cornerRadius = CardView.cornerRadius
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = .init(width: 0, height: 2)
        self.layer.shadowRadius = CardView.cornerRadius
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func viewHierarchy() {
        super.addSubview(contentView)
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
