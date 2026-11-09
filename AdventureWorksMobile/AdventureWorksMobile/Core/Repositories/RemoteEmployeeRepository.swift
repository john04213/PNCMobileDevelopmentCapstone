//
//  RemoteEmployeeRepository.swift
//  AdventureWorksMobile
//
//  Created by Harris Riley on 11/5/26.
//

import Foundation

class RemoteEmployeeRepository: EmployeeRepositoryProtocol {

    private let urlBase: String
    private let listApi: RemoteRepositoryBase<EmployeeElement>
    private let profileApi: RemoteRepositoryBase<EmployeeProfile>

    init(urlBase: String, authStatus: AuthStatus) {
        self.urlBase = urlBase

        listApi = RemoteRepositoryBase<EmployeeElement>(authStatus: authStatus)
        profileApi = RemoteRepositoryBase<EmployeeProfile>(authStatus: authStatus)
    }

    func employees() async throws -> [EmployeeElement] {
        try await listApi.fetchAll("\(urlBase)/Employee")
    }

    func profile(id: Int) async throws -> EmployeeProfile {
        try await profileApi.fetchOne("\(urlBase)/Employee/\(id)")
    }
}
