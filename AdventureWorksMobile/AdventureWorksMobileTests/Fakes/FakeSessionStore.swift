//
//  FakeSessionStore.swift
//  AdventureWorksMobileTests
//
//  Created by John Hernandez on 10/11/26.
//

import Foundation
@testable import AdventureWorksMobile

@MainActor
// Instead of writing to KeyChain, it creates a report of what happened
// so the test can check it after
class FakeSessionStore: SessionStoring {
    var savedAccessToken: String? = nil
    var clearCount = 0
    
    func saveSession (accessToken: String, refreshToken: String) {
        savedAccessToken = accessToken
    }
    func clearSession(reason: String?) {
        clearCount += 1
    }
}
