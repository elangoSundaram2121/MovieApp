//
//  Throttler.swift
//  MovieApp
//
//  Created by esundaram esundaram on 10/02/23.
//

import Foundation
import UIKit

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
            //  obj.getSearchProducts(searchText: searchText) { (products) in
            //     block(products)
            //  }
            // here you hit the request and get back the data
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
    }
}
