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
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "No movies added to favourites yet"
        return label
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
        loadData()
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        configureDelegates()
        configureButton()
    }
    
    // MARK: Configuration/Setup
    
    private func configureViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(closeButton)
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateLabel)
        
        if movies.count == 0 {
            self.tableView.isHidden = true
            self.emptyStateView.isHidden = false
        }
        else {
            self.tableView.isHidden = false
            self.emptyStateView.isHidden = true
        }
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
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateView.bottomAnchor, constant: 0)
        ])
    }
    
    private func configureButton() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
    private func configureDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
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


