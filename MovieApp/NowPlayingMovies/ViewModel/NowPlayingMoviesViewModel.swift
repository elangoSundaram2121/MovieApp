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
    func reloadData(movies: [Movie])
    func reloadSearchData(searchMovies: [Movie])
    func showNoResultsState()
    func didFail(with error: ErrorHandler)
    func setNavigationTitle(to value: String)
}

/// The `ViewModel` that controls NowPlayingMovies UI 
class NowPlayingMoviesViewModel {

    // MARK: - Properties
    private let service: NowPlayingMoviesServiceProtocol
    private let searchService: SearchMoviesServiceProtocol

    private var movies: [Movie] = []
    private var searchResults: [Movie] = []
    private var currentPage: Int = 1
    private var isLoading = false

    weak var delegate: NowPlayingMoviesViewModelDelegate?
    weak var coordinator: NowPlayingMoviesCoordinatorType?

    // MARK: - Initialization

    init(
        service: NowPlayingMoviesServiceProtocol = NowPlayingMoviesService(),
        searchService: SearchMoviesServiceProtocol = SearchMoviesService()
    ) {
        self.service = service
        self.searchService = searchService
    }

    // MARK: Methods
    func getMovie(at indexPath: IndexPath) -> Movie {
        return movies[indexPath.row]
    }

    func getSearchResultsMovie(at indexPath: IndexPath) -> Movie {
        return searchResults[indexPath.row]
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

    func loadNowPlayingMovies() {
        delegate?.showLoading()
        getNowPlayingMovies()
    }

    func didSelectSearchRow(at indexPath: IndexPath) {
        let movie = getSearchResultsMovie(at: indexPath)
        coordinator?.goToMovieDetails(with: movie)
    }

    func userRequestedMoreData() {
        if !isLoading {
            delegate?.showPaginationLoading()
            getNowPlayingMovies()
        }
    }

    func getNowPlayingMovies() {
        isLoading = true
        service.getNowPlayingMovies(page: currentPage) { [weak self] result in
            switch result {
            case .success(let nowPlayingMovies):
                self?.movies.append(contentsOf: nowPlayingMovies.results)
                self?.currentPage = nowPlayingMovies.page + 1
                if let movies = self?.movies {
                    self?.delegate?.reloadData(movies: movies)
                }

            case .failure(let error):
                self?.delegate?.didFail(with: error)
            }
            self?.isLoading = false
            self?.delegate?.hideLoading()
        }
    }

    func searchMovies(with query: String) {

        searchService.searchMovie(query: query, page: currentPage) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.searchResults = movies.results
                let noResults = movies.results.isEmpty
                if noResults {
                    self?.delegate?.showNoResultsState()
                } else {
                    if let searchMovies = self?.searchResults {
                        self?.delegate?.reloadSearchData(searchMovies: searchMovies)
                    }
                }
            case .failure(let error):
                self?.delegate?.didFail(with: error)
            }
            self?.delegate?.hideLoading()
        }

    }

}
