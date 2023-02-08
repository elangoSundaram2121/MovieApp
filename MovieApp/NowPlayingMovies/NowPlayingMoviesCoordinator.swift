//
//  NowPlayingCoordinator.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import Foundation
import UIKit

/// High level protocol which  represents  the set of methods and properties that the `NowPlayingMoviesCoordinator` layer must contain,
public protocol NowPlayingMoviesCoordinatorType: Coordinator {

}

/// The Coordinator class to handle navigation in NowPlayingMoviesScreen of the app.
/// Also confirms to `NowPlayingMoviesCoordinatorType`
public class NowPlayingMoviesCoordinator: NowPlayingMoviesCoordinatorType {

    // MARK: - Coordinator's Properties
    public var childCoordinators: [Coordinator] = []

    public var parentCoordinator: Coordinator?

    private let navigationController: UINavigationController = .init()

    // MARK: - Helpers
    var rootViewController: UIViewController {
        navigationController.tabBarItem = UITabBarItem(title: "Now Playing", image: UIImage(systemName: "play"), selectedImage: UIImage(systemName: "play.fill"))
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }

    private func makeViewController() -> NowPlayingMoviesViewController {
        let viewModel = NowPlayingMoviesViewModel()
        viewModel.coordinator = self
        return NowPlayingMoviesViewController(viewModel: viewModel)
    }

    public func start() {
        navigationController.pushViewController(makeViewController(), animated: false)

    }
}
