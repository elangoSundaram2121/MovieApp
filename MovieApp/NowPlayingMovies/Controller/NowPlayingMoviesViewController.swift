//
//  NowPlayingViewController.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import UIKit

class NowPlayingMoviesViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: NowPlayingMoviesViewModel

    var searchBar = UISearchBar()
    var movies: [Movie] = []
    var searchResultsMovies: [Movie] = []
    var inSearchMode = false
    var searchTask: DispatchWorkItem?

    var nowPlayingTableViewEnabled = true
    var searchTableViewEnabled = false

    // TableView to display NowPlaying movies
    private let nowPlayingTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            MoviesCell.self,
            forCellReuseIdentifier: String(describing: MoviesCell.self)
        )
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // TableView to display Search results
    private let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            MoviesCell.self,
            forCellReuseIdentifier: String(describing: MoviesCell.self)
        )
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var nowPlayingTableViewDataSource: UITableViewDiffableDataSource<MovieSection, Movie> = {

        let dataSource = UITableViewDiffableDataSource<MovieSection, Movie>(tableView: nowPlayingTableView) {
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

    } ()

    private lazy var searchTableViewDataSource: UITableViewDiffableDataSource<MovieSection, Movie> = {

        let dataSource = UITableViewDiffableDataSource<MovieSection, Movie>(tableView: searchTableView) {
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

    } ()

    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "No Results Found"
        return label
    }()
    
    // MARK: Initialization
    
    init(viewModel: NowPlayingMoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        configureSearchBar()
        configureViews()
        configureConstraints()
        configureDelegates()
        loadData()
        configureMovieSnapShot()
        configureSearchResultsSnapShot()
    }

    func configureMovieSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<MovieSection, Movie>()
        snapshot.appendSections([.movie])
        snapshot.appendItems(movies, toSection: .movie)

        nowPlayingTableViewDataSource.apply(snapshot)
    }

    func configureSearchResultsSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<MovieSection, Movie>()
        snapshot.appendSections([.movie])
        snapshot.appendItems(searchResultsMovies, toSection: .movie)

        UIView.performWithoutAnimation {
            searchTableViewDataSource.apply(snapshot)
        }

    }
    
    // MARK: Configuration/Setup

    private func configureViews() {
        view.addSubview(nowPlayingTableView)
        view.addSubview(searchTableView)
        searchTableView.isHidden = true
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateView.isHidden = true
    }

    func configureSearchBar() {
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.barTintColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        searchBar.tintColor = .black
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            nowPlayingTableView.topAnchor.constraint(equalTo: view.topAnchor),
            nowPlayingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nowPlayingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nowPlayingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            searchTableView.topAnchor.constraint(equalTo: view.topAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            emptyStateView.centerXAnchor.constraint(equalTo: searchTableView.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: searchTableView.centerYAnchor),
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateView.bottomAnchor, constant: 12)
        ])
    }
    
    private func configureDelegates() {
        nowPlayingTableView.delegate = self
        searchTableView.delegate = self
        viewModel.delegate = self
    }
    
    // MARK: - Data Manipulation Methods
    
    private func loadData() {
        viewModel.loadNowPlayingMovies()
    }

}

// MARK: - UISearchBarDelegate Methods
extension NowPlayingMoviesViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        nowPlayingTableView.isHidden = true
        nowPlayingTableViewEnabled = false

        searchTableView.isHidden = false
        searchTableViewEnabled = true
        searchTableView.separatorColor = .lightGray
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty || searchText == "" {
            inSearchMode = false
            emptyStateView.isHidden = true
            searchTableView.isHidden = true
        } else {
            inSearchMode = true
            emptyStateView.isHidden = true
            searchTableView.isHidden = false
            self.searchTask?.cancel()
            let task = DispatchWorkItem { [weak self] in
                self?.searchMovies(text: searchText)
            }
            self.searchTask = task

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
        }
    }

    @objc func searchMovies(text: String) {
        viewModel.searchMovies(with: text)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text?.lowercased(){
            viewModel.searchMovies(with: searchText)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        inSearchMode = false

        emptyStateView.isHidden = true

        searchTableViewEnabled = false
        searchTableView.isHidden = true
        nowPlayingTableViewEnabled = true
        nowPlayingTableView.isHidden = false
        searchTableView.separatorColor = .clear
    }
}

// MARK: UITableViewDelegate/DataSource Methods
extension NowPlayingMoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView == searchTableView {
            viewModel.didSelectSearchRow(at: indexPath)
        } else {
            viewModel.didSelectRow(at: indexPath)
        }

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == nowPlayingTableView {
            let lastSection = tableView.numberOfSections - 1
            let lastRow = tableView.numberOfRows(inSection: lastSection) - 1
            if indexPath.section == lastSection && indexPath.row == lastRow {
                viewModel.userRequestedMoreData()
            }
        }
    }
}

// MARK: NowPlayingMoviesViewModelDelegate Methods

extension NowPlayingMoviesViewController: NowPlayingMoviesViewModelDelegate, Loadable, Alertable {

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
            self.nowPlayingTableView.tableFooterView = nil
        }
    }
    
    func showPaginationLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.nowPlayingTableView.tableFooterView = self.createFooterSpinner(on: self.nowPlayingTableView)
        }
    }
    
    func reloadData(movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async {
            self.configureMovieSnapShot()
        }
    }

    func reloadSearchData(searchMovies: [Movie]) {
        self.searchResultsMovies = searchMovies
        DispatchQueue.main.async {
            self.configureSearchResultsSnapShot()
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

    func showNoResultsState() {
        DispatchQueue.main.async { [weak self] in
            self?.searchTableView.isHidden = true
            self?.emptyStateView.isHidden = false
            self?.emptyStateLabel.text = "No results found"
        }
    }
    
    func setNavigationTitle(to value: String) {
        self.title = value
    }
}

// MARK: TableViewFooter Private Extension Methods
private extension NowPlayingMoviesViewController {
    private func createFooterSpinner(on tableView: UITableView) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100)
        return spinner
    }
}
