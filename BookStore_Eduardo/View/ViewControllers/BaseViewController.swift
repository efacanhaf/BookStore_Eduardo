//
//  BaseViewController.swift
//  BookStore_Eduardo
//
//  Created by eduardofilho on 27/04/22.
//

import Foundation
import UIKit
import SnapKit

class BaseViewController: UIViewController, CodeViewProtocol {
    internal static let defaultMargin: CGFloat = 16
    internal let baseViewModel: BaseViewModelProtocol

    init(viewModel: BaseViewModelProtocol) {
        baseViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = baseViewModel.title
        viewHierarchy()
        setupConstraints()
    }

    convenience required init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
    }
    
    func show(error: Error) {
        let action = UIAlertAction(title: String(localized: "Ok"), style: .default, handler: nil)
        let alertController = UIAlertController(title: String(localized: "GenericError"),
                                                message: String(localized: "GenericErrorMessage"),
                                                preferredStyle: .alert)
        alertController.addAction(action)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func viewHierarchy() { }   
    func setupConstraints() { }
}
