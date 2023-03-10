//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: MovieDetailsViewModel
    
    var isAddToFavouritesButtonClicked = false
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let imgView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28)
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(named: "AccentColor")
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let addToFavoritesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let goTofavouritesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        return button
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
    
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureButton()
        loadData()
        configureFavouriteButton()
        configureConstraints()
        configureDelegates()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.didFinishShowDetails()
    }
    
    // MARK: Configuration/Setup
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.addSubview(imgView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(subtitleLabel)
        scrollView.addSubview(overviewLabel)
        scrollView.addSubview(ratingLabel)
        scrollView.addSubview(scoreLabel)
        scrollView.addSubview(addToFavoritesButton)
        scrollView.addSubview(goTofavouritesButton)
        scrollView.addSubview(closeButton)
    }
    
    private func configureButton() {
        
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        
        addToFavoritesButton.backgroundColor = .black
        addToFavoritesButton.addTarget(self, action: #selector(didTapAddToFavourites), for: .touchUpInside)
        
        goTofavouritesButton.setTitle("Go to favourites", for: .normal)
        goTofavouritesButton.setTitleColor(.white, for: .normal)
        goTofavouritesButton.backgroundColor = .black
        goTofavouritesButton.addTarget(self, action: #selector(didTapGoToFavourites), for: .touchUpInside)
    }
    
    func configureFavouriteButton() {
        viewModel.favouriteMovies.forEach { favourite in
            if favourite.title == viewModel.movie.title {
                self.isAddToFavouritesButtonClicked.toggle()
            }
        }
        addToFavoritesButton.setTitle(self.isAddToFavouritesButtonClicked ? "Added to Favourites" : "Add to Favourites", for: .normal)
        self.addToFavoritesButton.isUserInteractionEnabled = self.isAddToFavouritesButtonClicked ? false : true
        addToFavoritesButton.setTitleColor(.white, for: .normal)
    }
    
    @objc private func didTapAddToFavourites() {
        self.isAddToFavouritesButtonClicked = !self.isAddToFavouritesButtonClicked
        self.configureFavouriteButton()
        viewModel.addFavourites()
    }
    
    
    
    private func configureConstraints() {
        let aspectRatio: CGFloat = 16 / 9  // The background image has 16:9 dimension
        
        let imageWidth: CGFloat = view.frame.size.width
        let imageHeight: CGFloat = imageWidth / aspectRatio
        let padding: CGFloat = 12
        let buttonSize: CGFloat = 30
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imgView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imgView.heightAnchor.constraint(equalToConstant: imageHeight),
            imgView.widthAnchor.constraint(equalToConstant: imageWidth),
            
            closeButton.topAnchor.constraint(equalTo: imgView.topAnchor, constant: padding),
            closeButton.trailingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: -padding),
            closeButton.widthAnchor.constraint(equalToConstant: buttonSize),
            closeButton.heightAnchor.constraint(equalToConstant: buttonSize),
            
            titleLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: imgView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: -padding),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            overviewLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: padding),
            overviewLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: padding),
            ratingLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            
            scoreLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: padding),
            scoreLabel.topAnchor.constraint(equalTo: ratingLabel.topAnchor),
            scoreLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -padding),
            
            addToFavoritesButton.leadingAnchor.constraint(equalTo: ratingLabel.leadingAnchor),
            addToFavoritesButton.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: padding),
            addToFavoritesButton.trailingAnchor.constraint(equalTo: overviewLabel.trailingAnchor, constant: -padding),
            
            goTofavouritesButton.leadingAnchor.constraint(equalTo: addToFavoritesButton.leadingAnchor),
            goTofavouritesButton.topAnchor.constraint(equalTo: addToFavoritesButton.bottomAnchor, constant: padding),
            goTofavouritesButton.trailingAnchor.constraint(equalTo: overviewLabel.trailingAnchor, constant: -padding)
            
        ])
    }
    
    private func configureDelegates() {
        viewModel.delegate = self
    }
    
    // MARK: - Action methods
    @objc private func didTapGoToFavourites() {
        
        viewModel.didTapFavourites()
    }
    
    @objc private func didTapClose() {
        viewModel.didFinishShowDetails()
    }
    
    // MARK: Data Manipulation Methods
    private func loadData() {
        viewModel.getMovie()
        viewModel.getFavouriteMovies()
    }
}


// MARK: UI Update

extension MovieDetailsViewController {
    private func updateView() {
        imgView.loadImage(
            from: viewModel.backdropImageURL,
            placeholder: UIImage(named: "BackdropPlaceholder")
        )

        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        overviewLabel.text = viewModel.overview
        ratingLabel.text = viewModel.ratingStars
        scoreLabel.text = viewModel.score
    }
}

// MARK: MovieDetailsViewModelDelegate Methods
extension MovieDetailsViewController: MovieDetailsViewModelDelegate, Loadable, Alertable {
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
        }
    }
    
    func didLoadMovieDetails() {
        DispatchQueue.main.async { [weak self] in
            self?.updateView()
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
}
