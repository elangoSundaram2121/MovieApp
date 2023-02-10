//
//  Throttler.swift
//  MovieApp
//
//  Created by esundaram esundaram on 10/02/23.
//

import Foundation
import UIKit


/**
 Throttler Class which helps for the searching tasks whenever a user types fast to
 make sure that, backend server doesn’t receive multiple requests
 */
class Throttler {
    private var searchTask: DispatchWorkItem?

    deinit {
        print("Throttler object deiniantialized")
    }
    func throttle(searchText: String, block: @escaping (_ movies: [Movie]) -> Void) {
        searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            guard let obj = self else {
                return
            }
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
    }
}
