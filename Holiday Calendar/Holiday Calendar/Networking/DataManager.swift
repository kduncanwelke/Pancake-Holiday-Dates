//
//  DataManager.swift
//  Holiday Calendar
//
//  Created by Kate Duncan-Welke on 10/8/21.
//

import Foundation

// object we ask to do the actual request
// takes generic searchtype conforming object, much more flexible than requesting a particular type
struct DataManager<T: RequestType> {
    private static func fetch(url: URL, completion: @escaping (Result<[T]>) -> Void) {
        // ask networker to get data
        Networker.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                // if we have the data, try to decode it
                guard let response = try? JSONDecoder.holidayApiDecoder.decode([T].self, from: data) else {
                    return
                }
                // it worked
                completion(.success(response))
            case .failure(let error):
                // it did not work
                completion(.failure(error))
            }
        }
    }

    // the function called from the viewmodel to request data when we load a month
    static func fetch(completion: @escaping (Result<[T]>) -> Void) {
        // call private function above
        fetch(url: T.endpoint.url()) { result in
            switch result {
            // use result
            case .success(let result):
                // if success take the info and put it into array of data
                var data: [T] = []
                for holiday in result {
                    data.append(holiday)
                }

                // deliver data
                completion(.success(data))
            case .failure(let error):
                // not work
                completion(.failure(error))
            }
        }
    }
}
