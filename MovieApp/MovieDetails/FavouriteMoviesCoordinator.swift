//
//  FavouriteMovieCoordinator.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import UIKit

protocol FavouriteMoviesCoordinatorType: Coordinator {
    func dismissFavouriteMovies()
}

final class FavouriteMoviesCoordinator: FavouriteMoviesCoordinatorType {
    // MARK: Properties

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: Methods

    private func makeViewController() -> FavouriteMoviesViewController {
        return FavouriteMoviesViewController(coordinator: self)
    }

    func start() {
        navigationController.present(self.makeViewController(), animated: true)
    }

    func dismissFavouriteMovies() {
        navigationController.dismiss(animated: true)
        finish()
    }
}
