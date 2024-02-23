//
//  City.swift
//  TMSLesson24
//
//  Created by Mac on 21.02.24.
//

import Foundation

struct City {
    let name: String
    let timeZoneIdentifier: String
    var timeZone: TimeZone? {
        return TimeZone(identifier: timeZoneIdentifier)
    }
}
