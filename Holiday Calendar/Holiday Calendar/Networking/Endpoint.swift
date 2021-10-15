//
//  Endpoint.swift
//  Holiday Calendar
//
//  Created by Kate Duncan-Welke on 10/8/21.
//

import Foundation

enum Endpoint {
    // this implementation allows for flexibility to add other calls although there is currently only one
    case holidays

    private var key: String {
        return ""
    }

    private var baseURL: URL {
        return URL(string: "https://holidays.abstractapi.com/v1/")!
    }

    // generate URL
    func url() -> URL {
        switch self {
        case .holidays:
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)

            // compose url, we know this will be a url so we are ok force unwrapping it
            components!.queryItems = [
                URLQueryItem(name: "api_key", value: key),
                URLQueryItem(name: "country", value: RequestConditions.country),
                URLQueryItem(name: "year", value: "\(RequestConditions.year)"),
                URLQueryItem(name: "month", value: "\(RequestConditions.month)"),
                URLQueryItem(name: "day", value: "\(RequestConditions.day)"),
            ]

            return components!.url!
        }
    }
}
