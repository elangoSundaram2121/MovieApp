//
//  NowPlayingMoviesViewModel.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import Foundation

protocol NowPlayingMoviesViewModelDelegate: AnyObject {
    func showPaginationLoading()
    func showLoading()
    func hideLoading()
    func reloadData()
    func didFail(with error: ErrorHandler)
    func setNavigationTitle(to value: String)
}

/// The `ViewModel` that controls NowPlayingMovies UI 
class NowPlayingMoviesViewModel {

    // MARK: - Properties
    private let service: NowPlayingMoviesServiceProtocol

    private var movies: [Movie] = []
    private var currentPage: Int = 1
    private var isLoading = false

    weak var delegate: NowPlayingMoviesViewModelDelegate?
    weak var coordinator: NowPlayingMoviesCoordinatorType?

    // MARK: - Initialization

    init(
        service: NowPlayingMoviesServiceProtocol = NowPlayingMoviesService()
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

    func didSelectFavouriteIcon() {
        coordinator?.goToFavouriteMovies()
    }

    // To-Do
    func setNavigationTitle() {
        delegate?.setNavigationTitle(to: "Now Playing")
    }

    func loadTopRatedMovies() {
        delegate?.showLoading()
        getNowPlayingMovies()
    }

    func userRequestedMoreData() {
        if !isLoading {
            delegate?.showPaginationLoading()
            getNowPlayingMovies()
        }
    }

    private func getNowPlayingMovies() {
        isLoading = true
        service.getNowPlayingMovies(page: currentPage) { [weak self] result in
            switch result {
            case .success(let nowPlayingMovies):
                self?.movies.append(contentsOf: nowPlayingMovies.results)
                self?.currentPage = nowPlayingMovies.page + 1
                self?.delegate?.reloadData()
            case .failure(let error):
                self?.delegate?.didFail(with: error)
            }
            self?.isLoading = false
            self?.delegate?.hideLoading()
        }
    }

}
