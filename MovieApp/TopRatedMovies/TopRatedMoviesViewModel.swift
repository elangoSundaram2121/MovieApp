//
//  TopRatedMoviesViewModel.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import Foundation

protocol TopRatedMoviesViewModelDelegate: AnyObject {
    func showPaginationLoading()
    func showLoading()
    func hideLoading()
    func reloadData()
    func didFail(with error: ErrorHandler)
    func setNavigationTitle(to value: String)
}


/// The `ViewModel` that controls TopRatedMovies UI 
class TopRatedMoviesViewModel {

    // MARK: - Properties
    private let service: TopRatedMoviesServiceProtocol

    private var movies: [Movie] = []
    private var currentPage: Int = 1
    private var isLoading = false

    weak var delegate: TopRatedMoviesViewModelDelegate?
    weak var coordinator: TopRatedMoviesCoordinatorType?

    // MARK: - Initialization

    init(
        service: TopRatedMoviesServiceProtocol = TopRatedMoviesService()
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
        delegate?.setNavigationTitle(to: "Top Rated")
    }

    func loadTopRatedMovies() {
        delegate?.showLoading()
        getTopRatedMovies()
    }

    func userRequestedMoreData() {
        if !isLoading {
            delegate?.showPaginationLoading()
            getTopRatedMovies()
        }
    }

    private func getTopRatedMovies() {
        isLoading = true
        service.getTopRatedMovies(page: currentPage) { [weak self] result in
            switch result {
            case .success(let topRatedMovies):
                self?.movies.append(contentsOf: topRatedMovies.results)
                self?.currentPage = topRatedMovies.page + 1
                self?.delegate?.reloadData()
            case .failure(let error):
                self?.delegate?.didFail(with: error)
            }
            self?.isLoading = false
            self?.delegate?.hideLoading()
        }
    }

}
