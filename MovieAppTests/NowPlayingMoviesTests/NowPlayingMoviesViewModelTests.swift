//
//  NowPlayingMoviesViewModelTests.swift
//  MovieAppTests
//
//  Created by esundaram esundaram on 10/02/23.
//

import XCTest

@testable import MovieApp

final class NowPlayingMoviesViewModelTests: XCTestCase {
    private let serviceSpy = NowPlayingMoviesMockService()
    private let delegateSpy = NowPlayingMoviesViewModelMockDelegate()
    private lazy var sut = NowPlayingMoviesViewModel(
        service: serviceSpy
    )
    
    func test_getMovieAtIndexPath_shouldReturnMovie() {
        // Given
        serviceSpy.getNowPlayingMoviesToBeReturned = .success(
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
        sut.loadNowPlayingMovies()
        let movie = sut.getMovie(at: IndexPath.init(row: 2, section: 1))
        
        // Then
        XCTAssertEqual(movie, Movie.fixture(title: "Thor"))
    }
    
    func test_numberOfRows_shouldReturnDataSourceCount() {
        // Given
        serviceSpy.getNowPlayingMoviesToBeReturned = .success(
            .fixture(
                results: [
                    Movie.fixture(),
                    Movie.fixture(),
                    Movie.fixture()
                ]
            )
        )
        
        // When
        sut.loadNowPlayingMovies()
        let numberOfRows = sut.numberOfRows()
        
        // Then
        XCTAssertEqual(numberOfRows, 3)
    }
    
    func test_loadNowPlayingMovies_shouldCallService_oneTime() {
        // Given
        let callCount = 1
        sut.delegate = delegateSpy
        
        // When
        sut.loadNowPlayingMovies()
        
        // Then
        XCTAssertTrue(delegateSpy.showLoadingCalled)
        XCTAssertTrue(serviceSpy.getNowPlayingMoviesCalled)
        XCTAssertEqual(serviceSpy.getNowPlayingMoviesCallCount, callCount)
    }
    
    func test_loadNowPlayingMovies_firstCall_shouldShowLoading_and_sendPageOneToService() {
        // Given
        let page = 1
        sut.delegate = delegateSpy
        
        // When
        sut.loadNowPlayingMovies()
        
        // Then
        XCTAssertTrue(delegateSpy.showLoadingCalled)
        XCTAssertEqual(page, serviceSpy.getNowPlayingMoviesPagePassed)
    }
    
    func test_userRequestedMoreData_shouldCallService_oneTime() {
        // Given
        let callCount = 1
        sut.delegate = delegateSpy
        
        // When
        sut.userRequestedMoreData()
        
        // Then
        XCTAssertTrue(delegateSpy.showPaginationLoadingCalled)
        XCTAssertTrue(serviceSpy.getNowPlayingMoviesCalled)
        XCTAssertEqual(serviceSpy.getNowPlayingMoviesCallCount, callCount)
    }
    
    func test_userRequestedMoreData_shouldShowLoading_and_callService() {
        // Given
        sut.delegate = delegateSpy
        
        // When
        sut.userRequestedMoreData()
        
        // Then
        XCTAssertTrue(delegateSpy.showPaginationLoadingCalled)
        XCTAssertTrue(serviceSpy.getNowPlayingMoviesCalled)
    }
    
    func test_getNowPlayingMovies_firstCall_shouldPaginate_toPageTwo() {
        // Given
        let page = 2
        serviceSpy.getNowPlayingMoviesToBeReturned = .success(.fixture(page: 1))
        sut.delegate = delegateSpy
        sut.loadNowPlayingMovies()
        
        // When
        sut.userRequestedMoreData()
        
        // Then
        XCTAssertTrue(delegateSpy.reloadDataCalled)
        XCTAssertEqual(serviceSpy.getNowPlayingMoviesPagePassed, page)
        XCTAssertEqual(serviceSpy.getNowPlayingMoviesCallCount, 2)
        XCTAssertTrue(delegateSpy.hideLoadingCalled)
    }
    
    func test_getNowPlayingMovies_shouldPaginate_manyTimesServiceIsCalled() {
        // Given
        let finalPage = 5
        let callCount = 5
        sut.delegate = delegateSpy
        
        // When
        for i in 1...callCount {
            serviceSpy.getNowPlayingMoviesToBeReturned = .success(.fixture(page: i))
            sut.userRequestedMoreData()
        }
        
        // Then
        XCTAssertTrue(delegateSpy.reloadDataCalled)
        XCTAssertEqual(serviceSpy.getNowPlayingMoviesPagePassed, finalPage)
        XCTAssertEqual(serviceSpy.getNowPlayingMoviesCallCount, callCount)
        XCTAssertTrue(delegateSpy.hideLoadingCalled)
    }
    
    func test_getNowPlayingMovies_withSuccess_shouldReloadData() {
        // Given
        serviceSpy.getNowPlayingMoviesToBeReturned = .success(.fixture())
        sut.delegate = delegateSpy
        
        // When
        sut.loadNowPlayingMovies()
        
        // Then
        XCTAssertTrue(delegateSpy.reloadDataCalled)
        XCTAssertTrue(delegateSpy.hideLoadingCalled)
    }
    
    func test_getNowPlayingMovies_shouldFail_withError() {
        // Given
        let fakeError = ErrorHandler.invalidData
        serviceSpy.getNowPlayingMoviesToBeReturned = .failure(fakeError)
        sut.delegate = delegateSpy
        
        // When
        sut.loadNowPlayingMovies()
        
        // Then
        XCTAssertTrue(delegateSpy.didFailCalled)
        XCTAssertEqual(delegateSpy.didFailCalledErrorPassed, fakeError)
        XCTAssertTrue(delegateSpy.hideLoadingCalled)
    }
}


