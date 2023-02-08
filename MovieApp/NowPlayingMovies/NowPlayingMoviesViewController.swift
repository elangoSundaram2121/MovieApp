//
//  NowPlayingViewController.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import UIKit

class NowPlayingMoviesViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: NowPlayingMoviesViewModel

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARK: - Initializers
    init(viewModel: NowPlayingMoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
