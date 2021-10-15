//
//  ViewModel.swift
//  Holiday Calendar
//
//  Created by Kate Duncan-Welke on 10/8/21.
//

import Foundation
import UIKit

public class ViewModel {

    // MARK: Variables

    let calendar = Calendar.current
    var indexToUpdate = 0
    var loadingData = false

    // MARK: Data handling

    func getMonth() {
        // date to work with
        let chosenDate = CalendarInfo.dateToUse
        let range = calendar.range(of: .day, in: .month, for: chosenDate)!

        // get number of days in month
        let numDays = range.count

        // get beginning of month
        if let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: chosenDate))) {

            // find day of week for start of the month
            let dayOfWeek = calendar.component(.weekday, from: startOfMonth)

            // get month and year for day
            if let month = calendar.dateComponents([.month], from: chosenDate).month, let year = calendar.dateComponents([.year], from: chosenDate).year {

                // set in calendar model
                CalendarInfo.currentYear = year
                CalendarInfo.currentMonth = month

                // reset conditions for api requests
                RequestConditions.year = year
                RequestConditions.month = month
                RequestConditions.day = 1

                // if this is a new month we haven't added to the calendar yet, we need to query for its holidays
                if loadingNewMonth() {
                    loadingData = true
                    getHolidays()
                } else {
                    loadingData = false
                }

                // create month data object
                let newMonthData = DaysInMonth(beginningDayOfWeek: dayOfWeek, daysInMonth: numDays)

                // add year to calendar dictionary if it isn't present
                if CalendarInfo.data[year] == nil {
                    CalendarInfo.data[year] = [Int: DaysInMonth]()
                }

                // add month info to calendar dictionary if it isn't present
                if CalendarInfo.data[year]?[month] == nil {
                    CalendarInfo.data[year]?.updateValue(newMonthData, forKey: month)
                }
            }
        }
    }

    func hasNetwork() -> Bool {
        return NetworkMonitor.connection
    }

    func isLoading() -> Bool {
        // used to checking if queries are in progress
        return loadingData
    }

    func loadingNewMonth() -> Bool {
        // check if new month is being loaded
        if CalendarInfo.data[CalendarInfo.currentYear]?[CalendarInfo.currentMonth] == nil {
            return true
        } else {
            return false
        }
    }

    func getHolidays() {
        print("fetch")
        // get holidays for current selected date
        DataManager<HolidayData>.fetch() { result in
            switch result {
            case .success(let response):
                print(response)
                self.addHolidaysToDictionary(holidays: response)
            case .failure(let error):
                print(error)
                // no longer loading
                self.loadingData = false

                // handle failure case, as when connection is lost
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "networkFail"), object: nil)
            }
        }
    }

    func getNext() {
        var daysInMonth = getMonthDays()
        var startDayForWeek = getWeekStart()

        // assign index for calendar cell to update
        // this provides 'live' updates rather than waiting for all data
        // makes rate limit appear less slowing
        indexToUpdate = RequestConditions.day + (startDayForWeek - 2)

        // update cells as data is loaded to provide more feedback to user
        if HolidayDates[CalendarInfo.stringyDate] != nil {
            print("has date")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCell"), object: nil)
        }

        // if current request day is the same as the number of days in that month, loading holidays is complete for the month
        if RequestConditions.day == daysInMonth {
            // no longer in the loading process
            loadingData = false

            // pass alone completion
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "holidaysLoaded"), object: nil)
            return
        } else if RequestConditions.day < daysInMonth {
            // still haven't queried every day of the month, continue
            RequestConditions.day += 1

            // add delay before request as rate limit is once per second
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.getHolidays()
            }
        }
    }

    func addHolidaysToDictionary(holidays: [HolidayData]) {
        // add retrieved holidays to dictionary by date
        for holiday in holidays {
            CalendarInfo.stringyDate = holiday.date

            if HolidayDates[holiday.date] == nil {
                // if no array, add one
                HolidayDates[holiday.date] = [holiday]
                print("add holiday with array")
            } else {
                // if array present, append to it
                HolidayDates[holiday.date]?.append(holiday)
                print("add holiday")
            }
        }

        // prepare to query next date
        getNext()
    }

    // MARK: Calendar config

    func getWeekStart() -> Int {
        return CalendarInfo.data[CalendarInfo.currentYear]?[CalendarInfo.currentMonth]?.beginningDayOfWeek ?? 1
    }

    func getMonthDays() -> Int {
        return CalendarInfo.data[CalendarInfo.currentYear]?[CalendarInfo.currentMonth]?.daysInMonth ?? 30
    }

    func getMonthLabel() -> String {
        // label for month/year on calendar
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL YYYY"
        return dateFormatter.string(from: CalendarInfo.dateToUse)
    }

    func goBack() {
        // navigate to previous month
        CalendarInfo.direction = -1
        changeDirection()
    }

    func goForward() {
        // navigate to next month
        CalendarInfo.direction = 1
        changeDirection()
    }

    func changeDirection() {
        // get new date for navigating between months
        if let newDate = calendar.date(byAdding: .month, value: CalendarInfo.direction, to: CalendarInfo.dateToUse) {
            // use this date
            CalendarInfo.dateToUse = newDate

            // get calendar and holidays for this month
            getMonth()
        }
    }

    func performJump() {
        // create new date to jump to
        var components = DateComponents()
        components.year = CalendarInfo.jumpToYear
        components.month = CalendarInfo.jumpToMonth
        components.day = 1

        // get new date for navigating between months
        if let newDate = calendar.date(from: components) {
            // use this date
            CalendarInfo.dateToUse = newDate

            // get calendar and holidays for this month
            getMonth()
        }
    }

    func getUpdateIndex() -> Int {
        // index for updating calendar cells
        return indexToUpdate
    }

    func getBackgroundColor(index: Int) -> UIColor {
        var daysInMonth = getMonthDays()
        var startDayForWeek = getWeekStart()

        // dates outside of calendar range (less than the start day of week, more than the number of days in the week) will have the background color
        if (index + 1) < startDayForWeek || (index + 1) >= (daysInMonth + startDayForWeek) {
            return Colors.tan
        } else if ((index + 1) - (startDayForWeek - 1)) % 2 == 0 {
            // account for zero indexing and calendar weekdays
            return Colors.butter
        } else {
            return .white
        }
    }

    func pancakeKittyOpacity(index: Int) -> CGFloat {
        var stringDate = getStringDate(index: index)

        // if no array for this date there are no holidays for it, thus hide pancake kitty
        if HolidayDates[stringDate]?.isEmpty ?? true {
            return CGFloat(0)
        } else {
            return CGFloat(100)
        }
    }

    func getDaysTotal() -> Int {
        var daysInMonth = getMonthDays()
        var startDayForWeek = getWeekStart()

        // number of days on calendar has to be total for month
        // plus space to accomodate the week not beginning on sunday
        // minus one for startday as weekdays are not zero indexed
        return daysInMonth + (startDayForWeek - 1)
    }

    func getDateLabel(index: Int) -> String {
        var daysInMonth = getMonthDays()
        var startDayForWeek = getWeekStart()

        // if index is less than the start day for the week or greater than the number of days in the month, no calendar date will be shown, as these are empty days
        if (index + 1) < startDayForWeek || (index + 1) >= (daysInMonth + startDayForWeek) {
            return ""
        } else {
            // otherwise this is a date on the calendar
            // account for zero indexing on index and calendar weekdays not being zero indexed
            return "\((index + 1) - (startDayForWeek - 1))"
        }
    }

    // MARK: Picker

    func setDefault(component: Int) -> Int {
        var indexToUse = 0
        if component == 0 {
            // set month
            for i in 1...PickerData.data[component].count - 1 {
                if PickerData.data[component][i].value == CalendarInfo.currentMonth {
                    // set default month to jump to
                    CalendarInfo.jumpToMonth = PickerData.data[component][i].value
                    indexToUse = i
                }
            }
        } else {
            // set year
            for i in 1...PickerData.data[component].count - 1 {
                if PickerData.data[component][i].value == CalendarInfo.currentYear {
                    // set default year to jump to
                    CalendarInfo.jumpToYear = PickerData.data[component][i].value
                    indexToUse = i
                }
            }
        }

        return indexToUse
    }

    func getPickerCount() -> Int {
        return PickerData.data.count
    }

    func getRowsInComponent(component: Int) -> Int {
        return PickerData.data[component].count
    }

    func getTitle(component: Int, row: Int) -> String {
        return PickerData.data[component][row].name
    }

    func setSelections(component: Int, row: Int) {
        if component == 0 {
            // set month
            CalendarInfo.jumpToMonth = PickerData.data[component][row].value
            print(CalendarInfo.jumpToMonth)
        } else {
            // set year
            CalendarInfo.jumpToYear = PickerData.data[component][row].value
            print(CalendarInfo.jumpToYear)
        }
    }

    // MARK: Holiday info

    func setStringDate(index: Int) {
        CalendarInfo.stringyDate = getStringDate(index: index)
    }

    func stringy() -> String {
        return CalendarInfo.stringyDate
    }

    func getDateDay() -> String {
        return HolidayDates[CalendarInfo.stringyDate]?.first?.weekDay ?? ""
    }

    func getHolidayCountForDate() -> Int {
        return HolidayDates[CalendarInfo.stringyDate]?.count ?? 0
    }

    func getHolidayName(index: Int) -> String {
        return HolidayDates[CalendarInfo.stringyDate]?[index].name ?? ""
    }

    func getHolidayCountry(index: Int) -> String {
        return HolidayDates[CalendarInfo.stringyDate]?[index].country ?? ""
    }

    func getHolidayType(index: Int) -> String {
        return HolidayDates[CalendarInfo.stringyDate]?[index].type ?? ""
    }

    // MARK: Helper functions

    func getStringDate(index: Int) -> String {
        var startDayForWeek = getWeekStart()
        // add to index to account for zero indexing and subtract from weekday to account for placement on calendar
        var newIndex = (index + 1) - (startDayForWeek - 1)
        var dayZero = ""
        var monthZero = ""

        // if date is under ten, zero must be appended to front to match holiday data
        if newIndex < 10 {
            dayZero = "0"
        }

        // if date is under ten, zero must be appended to front to match holiday data
        if CalendarInfo.currentMonth < 10 {
            monthZero = "0"
        }

        // compose date month/day/year format
        return "\(monthZero)\(CalendarInfo.currentMonth)/\(dayZero)\(newIndex)/\(CalendarInfo.currentYear)"
    }

    func startMonitoring() {
        // monitor connection status
        NetworkMonitor.monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                NetworkMonitor.connection = true
            } else {
                NetworkMonitor.connection = false
            }
        }

        let queue = DispatchQueue(label: "Monitor")
        NetworkMonitor.monitor.start(queue: queue)
    }
}
