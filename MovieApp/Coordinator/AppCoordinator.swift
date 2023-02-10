//
//  AppCoordinator.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    
    // MARK: Properties
    
    var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    private let tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.stackedLayoutAppearance = UITabBarItemAppearance()
        tabBarAppearance.backgroundColor = .systemBackground
        tabBarController.tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        tabBarController.tabBar.tintColor = .black
        return tabBarController
    }()
    
    var rootViewController: UIViewController {
        return tabBarController
    }
    
    // MARK: Methods
    
    func start() {
        
        let nowPlayingMoviesCoordinator = NowPlayingMoviesCoordinator()
        let topRatedMoviesCoordinator = TopRatedMoviesCoordinator()
        let popularMoviesCoordinator = PopularMoviesCoordinator()
        let upcomingMoviesCoordinator = UpcomingMoviesCoordinator()
        
        childCoordinators.append(nowPlayingMoviesCoordinator)
        childCoordinators.append(topRatedMoviesCoordinator)
        childCoordinators.append(popularMoviesCoordinator)
        childCoordinators.append(upcomingMoviesCoordinator)
        
        nowPlayingMoviesCoordinator.parentCoordinator = self
        topRatedMoviesCoordinator.parentCoordinator = self
        popularMoviesCoordinator.parentCoordinator = self
        upcomingMoviesCoordinator.parentCoordinator = self
        
        nowPlayingMoviesCoordinator.start()
        topRatedMoviesCoordinator.start()
        popularMoviesCoordinator.start()
        upcomingMoviesCoordinator.start()
        
        tabBarController.viewControllers = [
            nowPlayingMoviesCoordinator.rootViewController,
            topRatedMoviesCoordinator.rootViewController,
            popularMoviesCoordinator.rootViewController,
            upcomingMoviesCoordinator.rootViewController
        ]
    }
}

