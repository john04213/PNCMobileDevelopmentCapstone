//
//  Date+Formatting.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/1/26.
//

import Foundation

extension String {

    // The API sends dates like "2013-05-30T00:00:00".
    // This turns one into a short date like "May 30, 2013".
    var formattedAPIDate: String {
        let parser = DateFormatter()
        parser.locale = Locale(identifier: "en_US_POSIX")
        parser.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = parser.date(from: self) else {
            return self
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
