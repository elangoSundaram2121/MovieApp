//
//  TopRatedCoordinator.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import Foundation
import UIKit

/// High level protocol which  represents  the set of methods and properties that the `TopRatedMoviesCoordinator` layer must contain,
public protocol TopRatedMoviesCoordinatorType: Coordinator {

}

/// The Coordinator class to handle navigation in TopRatedMoviesMoviesScreen of the app.
/// Also confirms to `TopRatedMoviesCoordinatorType`
public class TopRatedMoviesCoordinator: TopRatedMoviesCoordinatorType {

    // MARK: - Coordinator's Properties
    public var childCoordinators: [Coordinator] = []

    public var parentCoordinator: Coordinator?

    private let navigationController: UINavigationController = .init()

    // MARK: Helpers

    var rootViewController: UIViewController {
        navigationController.tabBarItem = UITabBarItem(title: "Top Rated", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    
    private func makeViewController() -> TopRatedMoviesViewController {
        let viewModel = TopRatedMoviesViewModel()
        viewModel.coordinator = self
        return TopRatedMoviesViewController(viewModel: viewModel)
    }

    public func start() {
        navigationController.pushViewController(makeViewController(), animated: false)

    }
}
