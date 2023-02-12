//
//  UpcomingMoviesViewController.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import UIKit

class UpcomingMoviesViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: UpcomingMoviesViewModel

    var movies: [Movie] = []

    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    private lazy var upcomingTableViewDataSource: UITableViewDiffableDataSource<MovieSection, Movie> = {

        let dataSource = UITableViewDiffableDataSource<MovieSection, Movie>(tableView: tableView) {
            tableview, indexpath, movie in
            guard let cell = tableview.dequeueReusableCell(withIdentifier: String(describing: MoviesCell.self)) as?
                    MoviesCell else {
                return UITableViewCell()
            }
            let cellViewModel = MoviesCellViewModel(movie: movie)
            cell.setup(with: cellViewModel)
            cell.selectionStyle = .none
            return cell
        }
        return dataSource

    }()
    
    // MARK: Initialization
    
    init(viewModel: UpcomingMoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureViews()
        configureConstraints()
        configureDelegates()
        configureTitle()
        loadData()
    }
    
    // MARK: Configuration/Setup

    func configureMovieSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<MovieSection, Movie>()
        snapshot.appendSections([.movie])
        snapshot.appendItems(movies, toSection: .movie)

        upcomingTableViewDataSource.apply(snapshot)
    }

    private func configureTableView() {
        tableView.register(
            MoviesCell.self,
            forCellReuseIdentifier: String(describing: MoviesCell.self)
        )
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureViews() {
        view.addSubview(tableView)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureDelegates() {
        tableView.delegate = self
        viewModel.delegate = self
    }
    
    private func configureTitle() {
        viewModel.setNavigationTitle()
    }
    
    // MARK: Data Manipulation Methods
    
    private func loadData() {
        viewModel.loadUpcomingMovies()
    }
}

// MARK: UITableViewDelegate/DataSource Methods
extension UpcomingMoviesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSection = tableView.numberOfSections - 1
        let lastRow = tableView.numberOfRows(inSection: lastSection) - 1
        if indexPath.section == lastSection && indexPath.row == lastRow {
            viewModel.userRequestedMoreData()
        }
    }
}

// MARK: NowPlayingMoviesViewModelDelegate Methods

extension UpcomingMoviesViewController: UpcomingMoviesViewModelDelegate, Loadable, Alertable {
    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showSpinner(on: self.view)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.removeSpinner(on: self.view)
            self.tableView.tableFooterView = nil
        }
    }
    
    func showPaginationLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.tableFooterView = self.createFooterSpinner(on: self.tableView)
        }
    }
    
    func reloadData(movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async { [weak self] in
            self?.configureMovieSnapShot()
        }
    }
    
    func didFail(with error: ErrorHandler) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showActionAlert(
                message: error.customMessage,
                action: self.loadData
            )
        }
    }
    
    func setNavigationTitle(to value: String) {
        self.title = value
    }
}

// MARK: TableViewFooter Private Extension Methods

private extension UpcomingMoviesViewController {
    private func createFooterSpinner(on tableView: UITableView) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100)
        return spinner
    }
}
