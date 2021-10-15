//
//  JSONDecoder.swift
//  Holiday Calendar
//
//  Created by Kate Duncan-Welke on 10/8/21.
//

import Foundation

// decoder for snakecase conversion
extension JSONDecoder {
    static var holidayApiDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
