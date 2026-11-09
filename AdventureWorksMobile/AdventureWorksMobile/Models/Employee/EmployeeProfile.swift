//
//  EmployeeProfile.swift
//  AdventureWorksMobile
//
//  Created by Harris Riley on 10/26/26.
//

import Foundation

// The full profile for one employee. From /api/Employee/{id}
class EmployeeProfile: Identifiable, Hashable, Codable {
    let employeeId: Int
    let employeeNumber: String
    let firstName: String
    let middleName: String?
    let lastName: String
    let suffix: String?
    let title: String?
    let jobTitle: String
    let shiftHistory: [EmployeeShiftHistory]

    var id: Int {
        employeeId
    }

    var fullName: String {
        var name = firstName
        if let middleName {
            name += " \(middleName)"
        }
        name += " \(lastName)"
        if let suffix, suffix != "" {
            name += " \(suffix)"
        }
        return name
    }

    init(employeeId: Int, employeeNumber: String, firstName: String, middleName: String?, lastName: String, suffix: String?, title: String?, jobTitle: String, shiftHistory: [EmployeeShiftHistory]) {
        self.employeeId = employeeId
        self.employeeNumber = employeeNumber
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.suffix = suffix
        self.title = title
        self.jobTitle = jobTitle
        self.shiftHistory = shiftHistory
    }

    static func == (lhs: EmployeeProfile, rhs: EmployeeProfile) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
