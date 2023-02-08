//
//  Alertable.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import Foundation
import UIKit

protocol Alertable: UIViewController {
    func showActionAlert(message: String, action: @escaping () -> Void)
    func showConfirmationAlert(message: String)
}

extension Alertable {
    func showActionAlert(message: String, action: @escaping () -> Void) {
        let alert = UIAlertController(title: "Ops", message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "Try Again", style: .default) { _ in
                action()
            }
        )
        alert.addAction(
            UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
                self?.dismiss(animated: true)
            }
        )
        present(alert, animated: true, completion: nil)
    }
    
    func showConfirmationAlert(message: String) {
        let confirm = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        confirm.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(confirm, animated: true, completion: nil)
    }
}
