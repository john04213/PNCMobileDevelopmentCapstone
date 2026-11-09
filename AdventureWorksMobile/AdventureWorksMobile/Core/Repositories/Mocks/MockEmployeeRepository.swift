//
//  MockEmployeeRepository.swift
//  AdventureWorksMobile
//
//  Created by Harris Riley on 11/5/26.
//

class MockEmployeeRepository: EmployeeRepositoryProtocol {

    private let employeeList: [EmployeeElement] = [
        EmployeeElement(
            employeeId: 275,
            firstName: "Michael",
            lastName: "Blythe",
            title: nil,
            shift: "Day",
            department: "Sales",
            hireDate: "2011-05-31T00:00:00",
            jobTitle: "Sales Representative"
        ),
        EmployeeElement(
            employeeId: 64,
            firstName: "Michael",
            lastName: "Zwilling",
            title: nil,
            shift: "Evening",
            department: "Production",
            hireDate: "2010-02-23T00:00:00",
            jobTitle: "Production Technician - WC60"
        ),
        EmployeeElement(
            employeeId: 227,
            firstName: "Gary",
            lastName: "Altman",
            title: nil,
            shift: "Day",
            department: "Facilities and Maintenance",
            hireDate: "2009-12-02T00:00:00",
            jobTitle: "Facilities Manager"
        ),
        EmployeeElement(
            employeeId: 285,
            firstName: "Syed",
            lastName: "Abbas",
            title: "Mr.",
            shift: "Day",
            department: "Sales",
            hireDate: "2013-03-14T00:00:00",
            jobTitle: "Pacific Sales Manager"
        )
    ]

    private let profiles: [EmployeeProfile] = [
        EmployeeProfile(
            employeeId: 275,
            employeeNumber: "841560125",
            firstName: "Michael",
            middleName: "G",
            lastName: "Blythe",
            suffix: nil,
            title: nil,
            jobTitle: "Sales Representative",
            shiftHistory: [
                EmployeeShiftHistory(
                    employeeId: 275,
                    departmentId: 3,
                    departmentName: "Sales",
                    departmentGroup: "Sales and Marketing",
                    shiftId: 1,
                    shiftName: "Day",
                    startDate: "2011-05-31T00:00:00",
                    endDate: nil
                )
            ]
        ),
        EmployeeProfile(
            employeeId: 64,
            employeeNumber: "582347317",
            firstName: "Michael",
            middleName: "J",
            lastName: "Zwilling",
            suffix: nil,
            title: nil,
            jobTitle: "Production Technician - WC60",
            shiftHistory: [
                EmployeeShiftHistory(
                    employeeId: 64,
                    departmentId: 7,
                    departmentName: "Production",
                    departmentGroup: "Manufacturing",
                    shiftId: 2,
                    shiftName: "Evening",
                    startDate: "2010-02-23T00:00:00",
                    endDate: nil
                )
            ]
        ),
        EmployeeProfile(
            employeeId: 227,
            employeeNumber: "141165819",
            firstName: "Gary",
            middleName: "E.",
            lastName: "Altman",
            suffix: "III",
            title: nil,
            jobTitle: "Facilities Manager",
            shiftHistory: [
                EmployeeShiftHistory(
                    employeeId: 227,
                    departmentId: 14,
                    departmentName: "Facilities and Maintenance",
                    departmentGroup: "Executive General and Administration",
                    shiftId: 1,
                    shiftName: "Day",
                    startDate: "2009-12-02T00:00:00",
                    endDate: nil
                )
            ]
        ),
        EmployeeProfile(
            employeeId: 285,
            employeeNumber: "481044938",
            firstName: "Syed",
            middleName: "E",
            lastName: "Abbas",
            suffix: nil,
            title: "Mr.",
            jobTitle: "Pacific Sales Manager",
            shiftHistory: [
                EmployeeShiftHistory(
                    employeeId: 285,
                    departmentId: 3,
                    departmentName: "Sales",
                    departmentGroup: "Sales and Marketing",
                    shiftId: 1,
                    shiftName: "Day",
                    startDate: "2013-03-14T00:00:00",
                    endDate: nil
                )
            ]
        )
    ]

    func employees() async throws -> [EmployeeElement] {
        return employeeList
    }

    func profile(id: Int) async throws -> EmployeeProfile {
        guard let found = profiles.first(where: { $0.id == id }) else {
            throw NetworkError.badResponse(statusCode: 404)
        }
        return found
    }
}
