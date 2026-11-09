//
//  EmployeeShiftHistory.swift
//  AdventureWorksMobile
//
//  Created by Harris Riley on 10/26/26.
//

import Foundation

// One stretch of time an employee worked in a department on a shift.
// Part of the profile from /api/Employee/{id}
class EmployeeShiftHistory: Identifiable, Hashable, Codable {
    let employeeId: Int
    let departmentId: Int
    let departmentName: String
    let departmentGroup: String
    let shiftId: Int
    let shiftName: String
    let startDate: String
    let endDate: String?

    // The API gives no id of its own, so build one from the pieces that make an entry unique.
    var id: String {
        "\(departmentId)-\(shiftId)-\(startDate)"
    }

    var startDateText: String {
        startDate.formattedAPIDate
    }

    // No end date means the employee is still there.
    var endDateText: String {
        if let endDate {
            return endDate.formattedAPIDate
        }
        return "Present"
    }

    init(employeeId: Int, departmentId: Int, departmentName: String, departmentGroup: String, shiftId: Int, shiftName: String, startDate: String, endDate: String?) {
        self.employeeId = employeeId
        self.departmentId = departmentId
        self.departmentName = departmentName
        self.departmentGroup = departmentGroup
        self.shiftId = shiftId
        self.shiftName = shiftName
        self.startDate = startDate
        self.endDate = endDate
    }

    static func == (lhs: EmployeeShiftHistory, rhs: EmployeeShiftHistory) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
