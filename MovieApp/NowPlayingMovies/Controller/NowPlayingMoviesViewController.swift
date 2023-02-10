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
    var filteredMovies: [Movie] = []
    var inSearchMode = false
    var searchTask: DispatchWorkItem?
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



    var nowPlayingTableViewEnabled = true
    var searchTableViewEnabled = false
    
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
        configureTitle()
        loadData()
    }
    
    // MARK: Configuration/Setup
    
    private func configureViews() {
        view.addSubview(nowPlayingTableView)
        view.addSubview(searchTableView)
        searchTableView.isHidden = true
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
            nowPlayingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: view.topAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureDelegates() {
        nowPlayingTableView.delegate = self
        nowPlayingTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        viewModel.delegate = self
    }
    
    private func configureTitle() {
        viewModel.setNavigationTitle()
    }
    
    // MARK: Data Manipulation Methods
    
    private func loadData() {
        viewModel.loadTopRatedMovies()
    }

}

extension NowPlayingMoviesViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        nowPlayingTableView.isHidden = true
        nowPlayingTableViewEnabled = false


    }



    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        searchTableView.isHidden = false
        searchTableViewEnabled = true
        searchTableView.separatorColor = .lightGray

        if searchText.isEmpty || searchText == " " {
            inSearchMode = false
            searchTableView.reloadData()
        } else {
            inSearchMode = true
            self.searchTask?.cancel()

            let task = DispatchWorkItem { [weak self] in
                self?.searchMovies(text: searchText)
            }
            self.searchTask = task

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
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

        searchTableViewEnabled = false
        searchTableView.isHidden = true
        nowPlayingTableViewEnabled = true
        nowPlayingTableView.isHidden = false
        searchTableView.separatorColor = .clear
        searchTableView.reloadData()
    }

    @objc func searchMovies(searchText: String){

    }
}

// MARK: UITableViewDelegate/DataSource Methods

extension NowPlayingMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTableView {
            return viewModel.numberOfRows()
        } else {
            return viewModel.numberOfRows()
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: MoviesCell.self),
                for: indexPath
            ) as? MoviesCell
            else { return UITableViewCell() }

        if tableView == searchTableView {
            let movie = viewModel.getSearchResultsMovie(at: indexPath)
            let movieCellViewModel = MoviesCellViewModel(movie: movie)

            cell.selectionStyle = .none
            cell.setup(with: movieCellViewModel)

            return cell
        } else {
            let movie = viewModel.getMovie(at: indexPath)
            let movieCellViewModel = MoviesCellViewModel(movie: movie)

            cell.selectionStyle = .none
            cell.setup(with: movieCellViewModel)

            return cell
        }



    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == searchTableView {

        } else {
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
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.nowPlayingTableView.reloadData()
        }
    }

    func reloadSearchData() {
        DispatchQueue.main.async { [weak self] in
            self?.searchTableView.reloadData()
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

private extension NowPlayingMoviesViewController {
    private func createFooterSpinner(on tableView: UITableView) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100)
        return spinner
    }
}
