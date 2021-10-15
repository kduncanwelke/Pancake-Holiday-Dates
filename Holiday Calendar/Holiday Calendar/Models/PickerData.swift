//
//  PickerData.swift
//  Holiday Calendar
//
//  Created by Kate Duncan-Welke on 10/14/21.
//

import Foundation

struct PickerData {

    static var data = [
        [
            PickerInfo(name: "January", value: 1),
            PickerInfo(name: "February", value: 2),
            PickerInfo(name: "March", value: 3),
            PickerInfo(name: "April", value: 4),
            PickerInfo(name: "May", value: 5),
            PickerInfo(name: "June", value: 6),
            PickerInfo(name: "July", value: 7),
            PickerInfo(name: "August", value: 8),
            PickerInfo(name: "September", value: 9),
            PickerInfo(name: "October", value: 10),
            PickerInfo(name: "November", value: 11),
            PickerInfo(name: "December", value: 12)
        ],
        [
            PickerInfo(name: "2012", value: 2012),
            PickerInfo(name: "2013", value: 2013),
            PickerInfo(name: "2014", value: 2014),
            PickerInfo(name: "2015", value: 2015),
            PickerInfo(name: "2016", value: 2016),
            PickerInfo(name: "2017", value: 2017),
            PickerInfo(name: "2018", value: 2018),
            PickerInfo(name: "2019", value: 2019),
            PickerInfo(name: "2020", value: 2020),
            PickerInfo(name: "2021", value: 2021),
            PickerInfo(name: "2022", value: 2022),
            PickerInfo(name: "2023", value: 2023),
            PickerInfo(name: "2024", value: 2024),
            PickerInfo(name: "2025", value: 2025),
            PickerInfo(name: "2026", value: 2026),
            PickerInfo(name: "2027", value: 2027),
            PickerInfo(name: "2028", value: 2028),
            PickerInfo(name: "2029", value: 2029),
            PickerInfo(name: "2030", value: 2030),
        ]
    ]
}

struct PickerInfo {
    var name: String
    var value: Int
}
