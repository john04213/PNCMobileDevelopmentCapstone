//
//  AuthServiceProtocol.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/9/26.
//

import Foundation

protocol AuthServiceProtocol {
    func login(credentials: LoginModel) async throws -> LoginResponse
}
