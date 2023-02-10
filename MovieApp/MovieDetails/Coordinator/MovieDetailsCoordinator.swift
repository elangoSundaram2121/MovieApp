//
//  MovieDetailsCoordinator.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import UIKit

protocol MovieDetailsCoordinatorType: Coordinator {
    func dismissMovieDetails()
    func goToFavourites()
}

final class MovieDetailsCoordinator: MovieDetailsCoordinatorType {
    // MARK: Properties
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let movie: Movie
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, movie: Movie) {
        self.navigationController = navigationController
        self.movie = movie
    }
    
    // MARK: Methods
    
    private func makeViewController() -> MovieDetailsViewController {
        let viewModel = MovieDetailsViewModel(movie: self.movie)
        viewModel.coordinator = self
        return MovieDetailsViewController(viewModel: viewModel)
    }
    
    func start() {
        navigationController.present(self.makeViewController(), animated: true)
    }
    
    func dismissMovieDetails() {
        navigationController.dismiss(animated: true)
        finish()
    }

    func goToFavourites() {
        self.dismissMovieDetails()
        let favouritesMovieCoordinator = FavouriteMoviesCoordinator(navigationController: navigationController)
        childCoordinators.append(favouritesMovieCoordinator)
        favouritesMovieCoordinator.parentCoordinator = self
        favouritesMovieCoordinator.start()
    }
}
