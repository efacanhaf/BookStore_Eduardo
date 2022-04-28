//
//  BookViewController.swift
//  BookStore_Eduardo
//
//  Created by eduardofilho on 28/04/22.
//

import Foundation
import UIKit
import SnapKit

class BookViewController: BookBaseViewController {
    fileprivate static let BuyBtnHeight: CGFloat = 30
    fileprivate static let BuyBtnFont: CGFloat = 16
    private var viewModel: BookViewModel {
        return baseViewModel as! BookViewModel
    }
    
    private let imageView = UIImageView()
    private let cardView = CardView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let buyBtn: RoundedButton = {
        let btn = RoundedButton()
        btn.setTitle(String(localized: "Buy"), for: .normal)
        btn.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return btn
    }()
    
    private let authorsLbl: UILabel = {
        let lbl = UILabel()
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.lineBreakStrategy = .pushOut
        lbl.font = .systemFont(ofSize: 14, weight: .light)
        lbl.textColor = .hex1C1C1C
        return lbl
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.isEditable = false
        tv.textAlignment = .justified
        return tv
    }()
    
    private let favoriteBtn: UIBarButtonItem = {
        let config = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "star", withConfiguration: config)
        let btn = UIBarButtonItem(image: image, style: .plain, target: nil, action: #selector(BookViewController.favorite))
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = viewModel.image
        authorsLbl.text = viewModel.authors
        buyBtn.isEnabled = viewModel.hasBuyLink
        
        favoriteBtn.isSelected = viewModel.isFavorited
        
        favoriteBtn.target = self
        self.navigationItem.rightBarButtonItem = favoriteBtn
        
        setupTextView()
    }
    
    override func viewHierarchy() {
        super.viewHierarchy()
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        cardView.addSubview(imageView)
        
        contentView.addSubview(cardView)
        contentView.addSubview(authorsLbl)
        contentView.addSubview(buyBtn)
        contentView.addSubview(textView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.height.width.equalToSuperview()
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
        }
        
        cardView.snp.makeConstraints { make in
            let itemWidth = ((self.view.frame.width/2) - BookViewController.defaultMargin * 2)
            let itemAspectedRationHeight = itemWidth * BookViewController.ImageRatioMultiplyer
            make.width.equalTo(itemWidth)
            make.height.equalTo(itemAspectedRationHeight)
            make.top.leading.equalToSuperview().inset(BookViewController.defaultMargin)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        authorsLbl.snp.makeConstraints { make in
            make.leading.equalTo(cardView.snp.trailing).offset(BookViewController.defaultMargin)
            make.top.trailing.equalToSuperview().inset(BookViewController.defaultMargin)
        }
        
        buyBtn.snp.makeConstraints { make in
            make.top.equalTo(authorsLbl.snp.bottom).offset(BookViewController.defaultMargin)
            make.leading.equalTo(authorsLbl)
            make.trailing.equalToSuperview().inset(BookViewController.defaultMargin)
            make.height.equalTo(BookViewController.BuyBtnHeight)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(BookViewController.defaultMargin)
            make.top.greaterThanOrEqualTo(buyBtn.snp.bottom).offset(BookViewController.defaultMargin)
            make.leading.trailing.bottom.equalToSuperview().inset(BookViewController.defaultMargin)
        }
    }
    
    func setupTextView() {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        
        let attributes = [NSAttributedString.Key.paragraphStyle : style,
                          .font : UIFont.systemFont(ofSize: BookViewController.BuyBtnFont, weight: .ultraLight),
                          .foregroundColor : UIColor.hex1C1C1C]
        
        textView.attributedText = NSAttributedString(string: viewModel.description, attributes: attributes)
    }
    
    @objc func didTap() {
        viewModel.buy()
    }
    
    @objc func favorite() {
        viewModel.isFavorited = !viewModel.isFavorited
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem?.isSelected = self.viewModel.isFavorited
        }
    }
}
