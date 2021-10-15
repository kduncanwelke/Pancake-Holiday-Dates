//
//  Result.swift
//  Holiday Calendar
//
//  Created by Kate Duncan-Welke on 10/8/21.
//

import Foundation

// enum to manage results from data manager
enum Result<Value> {
    case success(Value)
    case failure(Error)
}
