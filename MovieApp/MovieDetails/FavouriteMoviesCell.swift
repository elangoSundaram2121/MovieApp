//
//  FavouriteMoviesCell.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import Foundation
import UIKit

class FavouriteMoviesCell: UITableViewCell {

    private let movieImage: CachedImageView = {
        let imageView = CachedImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()

    private let starImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor(named: "AccentColor")
        return imageView
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    // MARK: Initializaton

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configuration/Setup

    private func configureViews() {
        contentView.addSubview(movieImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(starImgView)
        contentView.addSubview(ratingLabel)
    }

    private func configureConstraints() {

        // A movie poster has 3:2 dimension, so aspect ratio is 1.5
        let aspectRatio: CGFloat = 3 / 2

        let heightImageSize: CGFloat = 120
        let widthImageSize: CGFloat = heightImageSize / aspectRatio
        let padding: CGFloat = 12
        let starRatingSpacing: CGFloat = 3

        // Set a constraint priority to avoid warnings and specify to autolayout the correct height of cell
        let heightAnchor = movieImage.heightAnchor.constraint(equalToConstant: heightImageSize)
        heightAnchor.priority = .defaultHigh

        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            movieImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            movieImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            movieImage.widthAnchor.constraint(equalToConstant: widthImageSize),
            heightAnchor,

            titleLabel.topAnchor.constraint(equalTo: movieImage.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            starImgView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            starImgView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            ratingLabel.leadingAnchor.constraint(equalTo: starImgView.trailingAnchor, constant: starRatingSpacing),
            ratingLabel.centerYAnchor.constraint(equalTo: starImgView.centerYAnchor)
        ])
    }

    override func prepareForReuse() {
        movieImage.image = nil
        titleLabel.text = nil
        ratingLabel.text = nil
        super.prepareForReuse()
    }

    func setup(with viewModel: FavouriteMoviesCellViewModel) {
        movieImage.loadImage(
            from: viewModel.posterImageURL,
            placeholder: UIImage(named: "PosterPlaceholder")
        )
        titleLabel.text = viewModel.title
        ratingLabel.text = viewModel.rating
    }

}

