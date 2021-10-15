//
//  RequestData.swift
//  Holiday Calendar
//
//  Created by Kate Duncan-Welke on 10/8/21.
//

import Foundation

// object for data from api
struct HolidayData: RequestType {
    static var endpoint = Endpoint.holidays

    var name: String
    var nameLocal: String
    var description: String
    var country: String
    var type: String
    var date: String
    var dateYear: String
    var dateMonth: String
    var dateDay: String
    var weekDay: String
}
