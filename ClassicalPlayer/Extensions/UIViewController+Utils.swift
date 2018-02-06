//
//  UIViewControllerExtension.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/12/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    func showError(error: String, title: String? = "Error".localized(), actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        let alertActions = actions ?? [UIAlertAction(title: "OK".localized(), style: .default, handler: nil)]
        alertActions.forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
}

extension Reactive where Base: UIViewController {
    var errorPresentor: Binder<String> {
        return Binder(self.base) { controller, error in
            controller.showError(error: error)
        }
    }
}
