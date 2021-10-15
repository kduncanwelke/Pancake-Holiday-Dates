//
//  Calendar.swift
//  Holiday Calendar
//
//  Created by Kate Duncan-Welke on 10/9/21.
//

import Foundation

struct CalendarInfo {

    // dictionary for calendar, [year: [month: month info object]
    static var data = [Int: [Int: DaysInMonth]]()

    // year and month we are on
    static var currentYear = 2021
    static var currentMonth = 10

    // date used for calendar calculations
    static var dateToUse = Date()
    static var stringyDate = ""

    // direction for handling month movements
    static var direction = 0
    static var jumpToMonth = 0
    static var jumpToYear = 0
}

struct DaysInMonth {
    var beginningDayOfWeek: Int
    var daysInMonth: Int
}
