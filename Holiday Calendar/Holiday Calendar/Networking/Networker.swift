//
//  Networker.swift
//  Holiday Calendar
//
//  Created by Kate Duncan-Welke on 10/8/21.
//

import Foundation

struct Networker {
    // create session to begin working with api
    private static let session = URLSession(configuration: .default)

    // create url endpoint, pass it to function to fetch data
    static func getURL(endpoint: URL, completion: @escaping (Result<Data>) -> Void) {
        fetchData(url: endpoint, completion: completion)
    }

    static func fetchData(url: URL, completion: @escaping (Result<Data>) -> Void) {
        // create request from url
        let request = URLRequest(url: url)

        // task to get data from the request url that will get the data from the url, a status code response, or an error
        let task = session.dataTask(with: request) { data, response, error in

            // check that there is a connection in network monior first to prevent attempting connection when impossible
            if NetworkMonitor.connection == false {
                completion(.failure(Errors.noNetwork))
                return
            }

            // if there isn't some a code here the task didn't go right
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(Errors.networkError))
                return
            }

            if httpResponse.statusCode == 200 {
                // if status is 200 it's ok
                // check for error or data
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    completion(.success(data))
                }
            } else {
                // something else happened and there is another response code
                if httpResponse.statusCode == 422 {
                    // this code means the api limit has been hit, show special alert
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "limitAlert"), object: nil)
                    completion(.failure(Errors.limitHit))
                } else {
                    completion(.failure(Errors.networkError))
                    print("status was not 200")
                    print(httpResponse.statusCode)
                }
            }
        }
        
        // start task
        task.resume()
    }
}
