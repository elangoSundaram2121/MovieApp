//
//  UpcomingMoviesCoordinator.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import Foundation
import UIKit

/// High level protocol which  represents  the set of methods and properties that the `TopRatedMoviesCoordinator` layer must contain,
public protocol UpcomingMoviesCoordinatorType: Coordinator {
    
}

/// The Coordinator class to handle navigation in UpcomingMoviesScreen of the app.
/// Also confirms to `UpcomingMoviesCoordinatorType`
public class UpcomingMoviesCoordinator: UpcomingMoviesCoordinatorType {

    // MARK: - Coordinator's Properties

    public var childCoordinators: [Coordinator] = []

    public var parentCoordinator: Coordinator?

    private let navigationController: UINavigationController = .init()

    // MARK: Helpers

    var rootViewController: UIViewController {
        navigationController.tabBarItem = UITabBarItem(title: "Upcoming", image: UIImage(systemName: "seal"), selectedImage: UIImage(systemName: "seal.fill"))
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    
    private func makeViewController() -> UpcomingMoviesViewController {
        let viewModel = UpcomingMoviesViewModel()
        viewModel.coordinator = self
        return UpcomingMoviesViewController(viewModel: viewModel)
    }

    public func start() {
        navigationController.pushViewController(makeViewController(), animated: false)

    }
}
