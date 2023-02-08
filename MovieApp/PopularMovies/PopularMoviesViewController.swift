//
//  PopularMoviesViewController.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import UIKit

class PopularMoviesViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: PopularMoviesViewModel

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARK: - Initializers
    init(viewModel: PopularMoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
