//
//  PopularMoviesViewModelMockDelegate.swift
//  MovieAppTests
//
//  Created by esundaram esundaram on 10/02/23.
//

import XCTest

@testable import MovieApp

final class NowPlayingMoviesViewModelMockDelegate: NowPlayingMoviesViewModelDelegate {
    func reloadSearchData() {}
    
    private(set) var showLoadingCalled = false
    func showLoading() {
        showLoadingCalled = true
    }
    
    private(set) var showPaginationLoadingCalled = false
    func showPaginationLoading() {
        showPaginationLoadingCalled = true
    }
    
    private(set) var hideLoadingCalled = false
    func hideLoading() {
        hideLoadingCalled = true
    }
    
    private(set) var reloadDataCalled = false
    func reloadData() {
        reloadDataCalled = true
    }
    
    private(set) var didFailCalled = false
    private(set) var didFailCalledErrorPassed: ErrorHandler?
    func didFail(with error: ErrorHandler) {
        didFailCalled = true
        didFailCalledErrorPassed = error
    }
    
    private(set) var setNavigationTitleCalled = false
    private(set) var setNavigationTitleValuePassed: String?
    func setNavigationTitle(to value: String) {
        setNavigationTitleCalled = true
        setNavigationTitleValuePassed = value
    }
}

