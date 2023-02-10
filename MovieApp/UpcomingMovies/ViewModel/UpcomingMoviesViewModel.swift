//
//  UpcomingMoviesViewModel.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import Foundation

protocol UpcomingMoviesViewModelDelegate: AnyObject {
    func showPaginationLoading()
    func showLoading()
    func hideLoading()
    func reloadData()
    func didFail(with error: ErrorHandler)
    func setNavigationTitle(to value: String)
}

/// The `ViewModel` that controls NowPlayingMovies UI
class UpcomingMoviesViewModel {

    // MARK: - Properties
    private let service: UpcomingMoviesServiceProtocol

    private var movies: [Movie] = []
    private var currentPage: Int = 1
    private var isLoading = false

    weak var delegate: UpcomingMoviesViewModelDelegate?
    weak var coordinator: UpcomingMoviesCoordinatorType?

    // MARK: - Initialization

    init(
        service: UpcomingMoviesServiceProtocol = UpcomingMoviesService()
    ) {
        self.service = service
    }

    // MARK: Methods

    func getMovie(at indexPath: IndexPath) -> Movie {
        return movies[indexPath.row]
    }

    func numberOfRows() -> Int {
        return movies.count
    }

    func didSelectRow(at indexPath: IndexPath) {
        let movie = getMovie(at: indexPath)
        coordinator?.goToMovieDetails(with: movie)
    }

    // To-Do
    func setNavigationTitle() {
        delegate?.setNavigationTitle(to: "Upcoming")
    }

    func loadTopRatedMovies() {
        delegate?.showLoading()
        getUpcomingMovies()
    }

    func userRequestedMoreData() {
        if !isLoading {
            delegate?.showPaginationLoading()
            getUpcomingMovies()
        }
    }

    private func getUpcomingMovies() {
        isLoading = true
        service.getUpcomingMovies(page: currentPage) { [weak self] result in
            switch result {
            case .success(let upcomingMovies):
                self?.movies.append(contentsOf: upcomingMovies.results)
                self?.currentPage = upcomingMovies.page + 1
                self?.delegate?.reloadData()
            case .failure(let error):
                self?.delegate?.didFail(with: error)
            }
            self?.isLoading = false
            self?.delegate?.hideLoading()
        }
    }

}

