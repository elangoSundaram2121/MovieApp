//
//  PopularMoviesCoordinator.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import Foundation
import UIKit

/// High level protocol which  represents  the set of methods and properties that the `PopularMoviesCoordinator` layer must contain,
public protocol PopularMoviesCoordinatorType: Coordinator {

}

/// The Coordinator class to handle navigation in PopularMoviesScreen of the app.
/// Also confirms to `PopularMoviesCoordinatorType`
public class PopularMoviesCoordinator: PopularMoviesCoordinatorType {

    // MARK: - Coordinator's Properties
    
    public var childCoordinators: [Coordinator] = []

    public var parentCoordinator: Coordinator?

    private let navigationController: UINavigationController = .init()

    // MARK: - Helpers
    
    var rootViewController: UIViewController {
        navigationController.tabBarItem = UITabBarItem(title: "Popular", image: UIImage(systemName: "circle"), selectedImage: UIImage(systemName: "circle.fill"))
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }

    private func makeViewController() -> PopularMoviesViewController {
        let viewModel = PopularMoviesViewModel()
        viewModel.coordinator = self
        return PopularMoviesViewController(viewModel: viewModel)
    }

    public func start() {
        navigationController.pushViewController(makeViewController(), animated: false)

    }
}
