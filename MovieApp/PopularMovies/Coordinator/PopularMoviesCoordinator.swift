//
//  PopularMoviesCoordinator.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import Foundation
import UIKit

/// High level protocol which  represents  the set of methods and properties that the `PopularMoviesCoordinator` layer must contain,
protocol PopularMoviesCoordinatorType: Coordinator {
    func goToMovieDetails(with movie: Movie)
}

/// The Coordinator class to handle navigation in PopularMoviesScreen of the app.
/// Also confirms to `PopularMoviesCoordinatorType`
class PopularMoviesCoordinator: PopularMoviesCoordinatorType {

    // MARK: - Coordinator's Properties
    
    public var childCoordinators: [Coordinator] = []

    public var parentCoordinator: Coordinator?

    private let navigationController: UINavigationController = .init()

    // MARK: - Helpers
    
    var rootViewController: UIViewController {
        navigationController.tabBarItem = UITabBarItem(title: "Popular", image: UIImage(systemName: "film"),
                                                       selectedImage: UIImage(systemName: "film.fill"))
        navigationController.navigationBar.tintColor = .black
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

    func goToMovieDetails(with movie: Movie) {
        let movieDetailsCoordinator = MovieDetailsCoordinator(
            navigationController: navigationController,
            movie: movie
        )
        childCoordinators.append(movieDetailsCoordinator)
        movieDetailsCoordinator.parentCoordinator = self
        movieDetailsCoordinator.start()
    }
}
