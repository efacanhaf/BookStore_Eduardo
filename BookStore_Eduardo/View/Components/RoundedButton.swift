//
//  RoundedButton.swift
//  BookStore_Eduardo
//
//  Created by eduardofilho on 28/04/22.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = 15
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .tintColor : .systemGray2
        }
    }
}
