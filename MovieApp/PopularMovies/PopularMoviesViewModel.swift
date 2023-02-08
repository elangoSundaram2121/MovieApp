//
//  PopularMoviesViewModel.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import Foundation

protocol PopularMoviesViewModelDelegate: AnyObject {
    func showPaginationLoading()
    func showLoading()
    func hideLoading()
    func reloadData()
    func didFail(with error: ErrorHandler)
    func setNavigationTitle(to value: String)
}

class PopularMoviesViewModel {
    // MARK: Properties

    private let service: PopularMoviesServiceProtocol

    private var movies: [Movie] = []
    private var currentPage: Int = 1
    private var isLoading = false

    weak var delegate: PopularMoviesViewModelDelegate?
    weak var coordinator: PopularMoviesCoordinatorType?

    // MARK: Initialization

    init(
        service: PopularMoviesServiceProtocol = PopularMoviesService()
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

    func didSelectItem(at indexPath: IndexPath) {

    }

    // To-do
    func setNavigationTitle() {
        delegate?.setNavigationTitle(to: "Popular")
    }

    func loadPopularMovies() {
        delegate?.showLoading()
        getPopularMovies()
    }

    func userRequestedMoreData() {
        if !isLoading {
            delegate?.showPaginationLoading()
            getPopularMovies()
        }
    }

    private func getPopularMovies() {
        isLoading = true
        service.getPopularMovies(page: currentPage) { [weak self] result in
            switch result {
            case .success(let popularMovies):
                self?.movies.append(contentsOf: popularMovies.results)
                self?.currentPage = popularMovies.page + 1
                self?.delegate?.reloadData()
            case .failure(let error):
                self?.delegate?.didFail(with: error)
            }
            self?.isLoading = false
            self?.delegate?.hideLoading()
        }
    }
}
