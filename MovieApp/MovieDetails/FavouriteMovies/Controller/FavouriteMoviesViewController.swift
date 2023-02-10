//
//  FavouriteMovieController.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import CoreData
import UIKit

class FavouriteMoviesViewController: UIViewController {

    // MARK: Properties

    var movies: [FavouriteMovieDetails] = []

    var coordinator: FavouriteMoviesCoordinatorType

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            FavouriteMoviesCell.self,
            forCellReuseIdentifier: String(describing: FavouriteMoviesCell.self)
        )
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = UIColor(white: 0.25, alpha: 1)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    

    // MARK: Initialization

    init(coordinator: FavouriteMoviesCoordinatorType) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        configureDelegates()
        configureTitle()
        configureButton()
        loadData()
    }

    // MARK: Configuration/Setup

    private func configureViews() {
        view.addSubview(tableView)
        view.addSubview(closeButton)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([

            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),

            tableView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureButton() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }

    private func configureDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func configureTitle() {

    }

    @objc private func didTapClose() {
        self.coordinator.dismissFavouriteMovies()
    }

    // MARK: Data Manipulation Methods

    private func loadData() {
        let movieFetch: NSFetchRequest<FavouriteMovieDetails> = FavouriteMovieDetails.fetchRequest()

        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(movieFetch)
            movies = results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}

// MARK: UITableViewDelegate/DataSource Methods

extension FavouriteMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FavouriteMoviesCell.self),
            for: indexPath
        ) as? FavouriteMoviesCell
        else { return UITableViewCell() }

        let movie = movies[indexPath.row]
        let movieCellViewModel = FavouriteMoviesCellViewModel(movie: movie)

        cell.selectionStyle = .none
        cell.setup(with: movieCellViewModel)

        return cell
    }
}


