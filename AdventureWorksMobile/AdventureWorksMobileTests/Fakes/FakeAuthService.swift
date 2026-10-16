//
//  FakeAuthService.swift
//  AdventureWorksMobileTests
//
//  Created by John Hernandez on 10/11/26.
//

import Foundation
@testable import AdventureWorksMobile

@MainActor
class FakeAuthService: AuthServiceProtocol {
    var result: LoginResponse? = nil
    var errorToThrow: Error? = nil
    
    func login(credentials: LoginModel) async throws -> LoginResponse {
    if let errorToThrow { throw errorToThrow}
        return result!
    }
        
}
