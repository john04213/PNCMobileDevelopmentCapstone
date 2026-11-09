//
//  EmployeeListItem.swift
//  AdventureWorksMobile
//
//  Created by Harris Riley on 11/6/26.
//

import SwiftUI

// One row of the employee list. Tapping it opens that employee's profile.
struct EmployeeListItem: View {

    let employee: EmployeeElement

    var body: some View {
        NavigationLink(value: employee) {
            VStack(alignment: .leading) {
                Text(employee.fullName)
                    .bold()
                Text(employee.jobTitle)
                    .foregroundStyle(.secondary)
                Text("\(employee.department) · \(employee.shift) shift")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Hired \(employee.hireDateText) · ID \(employee.employeeId)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(employee.fullName), \(employee.jobTitle), \(employee.department), \(employee.shift) shift, hired \(employee.hireDateText)")
    }
}

#Preview {
    NavigationStack {
        List {
            EmployeeListItem(employee: EmployeeElement(employeeId: 275,
                                                       firstName: "Michael",
                                                       lastName: "Blythe",
                                                       title: nil,
                                                       shift: "Day",
                                                       department: "Sales",
                                                       hireDate: "2011-05-31T00:00:00",
                                                       jobTitle: "Sales Representative"))
        }
    }
}
