//
//  Errors.swift
//  Holiday Calendar
//
//  Created by Kate Duncan-Welke on 10/8/21.
//

import Foundation

// errors used in result delivered from datamanager
enum Errors: Error {
    case networkError
    case noNetwork
    case otherError
    case limitHit

    var localizedDescription: String {
        switch self {
        case .networkError:
            return "There was an error in networking - please wait and try again."
        case .noNetwork:
            return "The network is currently unavailable, please check your wifi or data connection."
        case .limitHit:
            return "The request limit for this API key has been hit. Data cannot be delivered."
        case .otherError:
            return "An unexpected error has occurred. Please wait and try again."
        }
    }
}
