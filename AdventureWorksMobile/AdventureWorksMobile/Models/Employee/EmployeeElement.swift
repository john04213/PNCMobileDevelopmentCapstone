//
//  EmployeeElement.swift
//  AdventureWorksMobile
//
//  Created by Harris Riley on 10/26/26.
//

import Foundation

// One row of the employee directory. From /api/Employee
class EmployeeElement: Identifiable, Hashable, Codable {
    let employeeId: Int
    let firstName: String
    let lastName: String
    let title: String?
    let shift: String
    let department: String
    let hireDate: String
    let jobTitle: String

    var id: Int {
        employeeId
    }

    var fullName: String {
        "\(firstName) \(lastName)"
    }

    var hireDateText: String {
        hireDate.formattedAPIDate
    }

    init(employeeId: Int, firstName: String, lastName: String, title: String?, shift: String, department: String, hireDate: String, jobTitle: String) {
        self.employeeId = employeeId
        self.firstName = firstName
        self.lastName = lastName
        self.title = title
        self.shift = shift
        self.department = department
        self.hireDate = hireDate
        self.jobTitle = jobTitle
    }

    static func == (lhs: EmployeeElement, rhs: EmployeeElement) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
