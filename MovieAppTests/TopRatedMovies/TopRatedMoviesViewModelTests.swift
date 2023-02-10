//
//  TopRatedMoviesViewModelTests.swift
//  MovieAppTests
//
//  Created by esundaram esundaram on 10/02/23.
//

import XCTest

@testable import MovieApp

final class ListTopRatedMoviesViewModelTests: XCTestCase {
    private let serviceSpy = TopRatedMoviesMockService()
    private let delegateSpy = TopRatedMoviesViewModelMockDelegate()
    private lazy var sut = TopRatedMoviesViewModel(
        service: serviceSpy
    )
    
    func test_getMovieAtIndexPath_shouldReturnMovie() {
        // Given
        serviceSpy.getTopRatedMoviesToBeReturned = .success(
            .fixture(
                results: [
                    Movie.fixture(title: "The Godfather"),
                    Movie.fixture(title: "The Shawshank Redemption"),
                    Movie.fixture(title: "Thor"),
                    Movie.fixture(title: "The Black Phone")
                ]
            )
        )
        
        // When
        sut.loadTopRatedMovies()
        let movie = sut.getMovie(at: IndexPath.init(row: 2, section: 1))
        
        // Then
        XCTAssertEqual(movie, Movie.fixture(title: "Thor"))
    }
    
    func test_numberOfRows_shouldReturnDataSourceCount() {
        // Given
        serviceSpy.getTopRatedMoviesToBeReturned = .success(
            .fixture(
                results: [
                    Movie.fixture(),
                    Movie.fixture(),
                    Movie.fixture()
                ]
            )
        )
        
        // When
        sut.loadTopRatedMovies()
        let numberOfRows = sut.numberOfRows()
        
        // Then
        XCTAssertEqual(numberOfRows, 3)
    }
    
    func test_setNavigationTitle_shouldSetTitleOnViewController() {
        // Given
        let title = "Top Rated"
        sut.delegate = delegateSpy
        
        // When
        sut.setNavigationTitle()
        
        // Then
        XCTAssertTrue(delegateSpy.setNavigationTitleCalled)
        XCTAssertEqual(delegateSpy.setNavigationTitleValuePassed, title)
    }
    
    func test_loadTopRatedMovies_shouldCallService_oneTime() {
        // Given
        let callCount = 1
        sut.delegate = delegateSpy
        
        // When
        sut.loadTopRatedMovies()
        
        // Then
        XCTAssertTrue(delegateSpy.showLoadingCalled)
        XCTAssertTrue(serviceSpy.getTopRatedMoviesCalled)
        XCTAssertEqual(serviceSpy.getTopRatedMoviesCallCount, callCount)
    }
    
    func test_loadTopRatedMovies_firstCall_shouldShowLoading_and_sendPageOneToService() {
        // Given
        let page = 1
        sut.delegate = delegateSpy
        
        // When
        sut.loadTopRatedMovies()
        
        // Then
        XCTAssertTrue(delegateSpy.showLoadingCalled)
        XCTAssertEqual(page, serviceSpy.getTopRatedMoviesPagePassed)
    }
    
    func test_userRequestedMoreData_shouldCallService_oneTime() {
        // Given
        let callCount = 1
        sut.delegate = delegateSpy
        
        // When
        sut.userRequestedMoreData()
        
        // Then
        XCTAssertTrue(delegateSpy.showPaginationLoadingCalled)
        XCTAssertTrue(serviceSpy.getTopRatedMoviesCalled)
        XCTAssertEqual(serviceSpy.getTopRatedMoviesCallCount, callCount)
    }
    
    func test_userRequestedMoreData_shouldShowLoading_and_callService() {
        // Given
        sut.delegate = delegateSpy
        
        // When
        sut.userRequestedMoreData()
        
        // Then
        XCTAssertTrue(delegateSpy.showPaginationLoadingCalled)
        XCTAssertTrue(serviceSpy.getTopRatedMoviesCalled)
    }
    
    func test_getTopRatedMovies_firstCall_shouldPaginate_toPageTwo() {
        // Given
        let page = 2
        serviceSpy.getTopRatedMoviesToBeReturned = .success(.fixture(page: 1))
        sut.delegate = delegateSpy
        sut.loadTopRatedMovies()
        
        // When
        sut.userRequestedMoreData()
        
        // Then
        XCTAssertTrue(delegateSpy.reloadDataCalled)
        XCTAssertEqual(serviceSpy.getTopRatedMoviesPagePassed, page)
        XCTAssertEqual(serviceSpy.getTopRatedMoviesCallCount, 2)
        XCTAssertTrue(delegateSpy.hideLoadingCalled)
    }
    
    func test_getTopRatedMovies_shouldPaginate_manyTimesServiceIsCalled() {
        // Given
        let finalPage = 5
        let callCount = 5
        sut.delegate = delegateSpy
        
        // When
        for i in 1...callCount {
            serviceSpy.getTopRatedMoviesToBeReturned = .success(.fixture(page: i))
            sut.userRequestedMoreData()
        }
        
        // Then
        XCTAssertTrue(delegateSpy.reloadDataCalled)
        XCTAssertEqual(serviceSpy.getTopRatedMoviesPagePassed, finalPage)
        XCTAssertEqual(serviceSpy.getTopRatedMoviesCallCount, callCount)
        XCTAssertTrue(delegateSpy.hideLoadingCalled)
    }
    
    func test_getTopRatedMovies_withSuccess_shouldReloadData() {
        // Given
        serviceSpy.getTopRatedMoviesToBeReturned = .success(.fixture())
        sut.delegate = delegateSpy
        
        // When
        sut.loadTopRatedMovies()
        
        // Then
        XCTAssertTrue(delegateSpy.reloadDataCalled)
        XCTAssertTrue(delegateSpy.hideLoadingCalled)
    }
    
    func test_getTopRatedMovies_shouldFail_withError() {
        // Given
        let fakeError = ErrorHandler.invalidData
        serviceSpy.getTopRatedMoviesToBeReturned = .failure(fakeError)
        sut.delegate = delegateSpy
        
        // When
        sut.loadTopRatedMovies()
        
        // Then
        XCTAssertTrue(delegateSpy.didFailCalled)
        XCTAssertEqual(delegateSpy.didFailCalledErrorPassed, fakeError)
        XCTAssertTrue(delegateSpy.hideLoadingCalled)
    }
}

