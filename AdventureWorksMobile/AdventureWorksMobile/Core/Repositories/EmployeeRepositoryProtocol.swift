//
//  EmployeeRepositoryProtocol.swift
//  AdventureWorksMobile
//
//  Created by Harris Riley on 11/5/26.
//

protocol EmployeeRepositoryProtocol {
    func employees() async throws -> [EmployeeElement]
    func profile(id: Int) async throws -> EmployeeProfile
}
