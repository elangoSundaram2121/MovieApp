//
//  UpcomingMoviesCoordinator.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import Foundation
import UIKit

/// High level protocol which  represents  the set of methods and properties that the `UpcomingMoviesCoordinator` layer must contain,
protocol UpcomingMoviesCoordinatorType: Coordinator {
    func goToMovieDetails(with movie: Movie)
}

/// The Coordinator class to handle navigation in UpcomingMoviesScreen of the app.
/// Also confirms to `UpcomingMoviesCoordinatorType`
class UpcomingMoviesCoordinator: UpcomingMoviesCoordinatorType {
    
    // MARK: - Coordinator's Properties
    
    public var childCoordinators: [Coordinator] = []
    
    public var parentCoordinator: Coordinator?
    
    private let navigationController: UINavigationController = .init()
    
    // MARK: Helpers
    
    var rootViewController: UIViewController {
        navigationController.tabBarItem = UITabBarItem(title: "Upcoming", image: UIImage(systemName: "arrow.rectanglepath"),
                                                       selectedImage: UIImage(systemName: "arrow.rectanglepath.fill"))
        navigationController.navigationBar.tintColor = .black
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
