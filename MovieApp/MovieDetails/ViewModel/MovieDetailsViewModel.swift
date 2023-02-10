//
//  MovieDetailsService.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import Foundation
import CoreData
import UIKit


protocol MovieDetailsViewModelDelegate: AnyObject {
    func showLoading()
    func hideLoading()
    func didLoadMovieDetails()
    func didFail(with error: ErrorHandler)
}

class MovieDetailsViewModel {
    
    // MARK: Properties
    
    var movie: Movie
    private var service: MovieDetailsServiceProtocol
    var favouriteMovies: [FavouriteMovieDetails] = []
    
    weak var delegate: MovieDetailsViewModelDelegate?
    weak var coordinator: MovieDetailsCoordinatorType?
    
    // MARK: Initialization
    
    init(
        service: MovieDetailsServiceProtocol = MovieDetailsService(),
        movie: Movie
    ) {
        self.service = service
        self.movie = movie
    }
    
    // MARK: Presentation Properties
    
    var id: Int {
        return movie.id
    }
    
    var backdropImageURL: String {
        guard let posterPath = movie.backdropPath else {
            return "https://image.xumo.com/v1/assets/asset/XM05YG2LULFZON/600x340.jpg"
        }
        return "https://image.tmdb.org/t/p/original" + posterPath
    }
    
    var title: String {
        return movie.title
    }
    
    var primaryGenre: String {
        guard let primaryGenre = movie.genres?.first?.name else {
            return "N/A"
        }
        return primaryGenre
    }
    
    var subtitle: String {
        guard
            let runtime = movie.runtime, runtime > 0,
            let duration = convertMinutesToHoursAndMinutes(runtime: runtime),
            let releaseDate = movie.releaseDate,
            let releaseYear = getYearComponentOfDate(date: releaseDate)
        else {
            return "N/A"
        }
        
        return "\(primaryGenre) • \(releaseYear) • \(duration)"
    }
    
    var overview: String {
        return movie.overview
    }
    
    var ratingStars: String {
        let truncatedRating = Int(movie.voteAverage)
        let ratingStars = (0 ..< truncatedRating).reduce("") { partialResult, _ -> String in
            return partialResult + "★"
        }
        return ratingStars
    }
    
    var score: String {
        let hasScore = movie.voteAverage > 0
        let truncatedScore = String(format: "%.1f", movie.voteAverage)
        
        return hasScore ? "\(truncatedScore)/10" : String()
    }
    
    // MARK: Methods
    
    func getMovie() {
        delegate?.showLoading()
        service.getMovie(id: movie.id) { [weak self] result in
            switch result {
            case .success(let movie):
                self?.movie = movie
                self?.delegate?.didLoadMovieDetails()
                self?.delegate?.hideLoading()
            case .failure(let error):
                self?.delegate?.didFail(with: error)
            }
        }
    }
    
    func getFavouriteMovies() {
        let movieFetch: NSFetchRequest<FavouriteMovieDetails> = FavouriteMovieDetails.fetchRequest()
        
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(movieFetch)
            favouriteMovies = results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func didFinishShowDetails() {
        coordinator?.dismissMovieDetails()
    }
    
    func didTapFavourites() {
        coordinator?.goToFavourites()
        
    }
    
    
    func addFavourites() {
        saveToCoreData()
    }
    
    // Saving Movie data using CoreData
    func saveToCoreData() {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let favouriteMovie = FavouriteMovieDetails(context: managedContext)
        favouriteMovie.setValue(self.movie.title, forKey: #keyPath(FavouriteMovieDetails.title))
        favouriteMovie.setValue(self.movie.overview, forKey: #keyPath(FavouriteMovieDetails.overview))
        favouriteMovie.setValue(self.movie.runtime, forKey: #keyPath(FavouriteMovieDetails.runtime))
        favouriteMovie.setValue(self.movie.voteAverage, forKey: #keyPath(FavouriteMovieDetails.voteAverage))
        favouriteMovie.setValue(self.movie.releaseDate, forKey: #keyPath(FavouriteMovieDetails.releaseDate))
        favouriteMovie.setValue(self.movie.backdropPath, forKey: #keyPath(FavouriteMovieDetails.backdropPath))
        favouriteMovie.setValue(self.movie.posterPath, forKey: #keyPath(FavouriteMovieDetails.posterPath))
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
}

// MARK: Utility Extensions

extension MovieDetailsViewModel {
    func convertMinutesToHoursAndMinutes(runtime: Int) -> String? {
        let dateComponentesFormatter = DateComponentsFormatter()
        dateComponentesFormatter.unitsStyle = .full
        dateComponentesFormatter.calendar?.locale = Locale(identifier: "en-US")
        dateComponentesFormatter.allowedUnits = [.hour, .minute]
        
        let hoursAndMinutes = dateComponentesFormatter.string(
            from: TimeInterval(runtime) * 60
        )
        
        return hoursAndMinutes
    }
    
    func getYearComponentOfDate(date: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: date) else {
            return nil
        }
        formatter.dateFormat = "yyyy"
        let yearOfRelease = formatter.string(from: date)
        
        return yearOfRelease
    }
}
