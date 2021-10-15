//
//  RequestType.swift
//  Holiday Calendar
//
//  Created by Kate Duncan-Welke on 10/8/21.
//

import Foundation

// protocol for search types, makes request endpoint, used for generics in data manager
protocol RequestType: Decodable {
    static var endpoint: Endpoint { get }
}
