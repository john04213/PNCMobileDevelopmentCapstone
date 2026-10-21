//
//  UserFacingMessageTests.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/17/26.
//

import Foundation
import Testing
@testable import AdventureWorksMobile


struct UserFacingMessageTests {
    @Test func offlineShowsOfflineMessage() {
        let error = URLError(.notConnectedToInternet)
        let message = UserFacingMessage.from(error)
        #expect(message == UserFacingMessage.offline)
    }
    
    @Test func timeoutShowsTimeOutMessage() {
        let error = URLError(.timedOut)
        let message = UserFacingMessage.from(error)
        #expect(message == UserFacingMessage.timedOut)
    }
    
    @Test func missingAuthTokenShowsMissingAuthTokenMessage() {
        let error = NetworkError.missingAuthToken
        let message = UserFacingMessage.from(error)
        #expect(message == UserFacingMessage.signInRequired)
    }
    
    @Test func unauthorizedShowsUnauthorizedMessage() {
        let error = NetworkError.unauthorized
        let message = UserFacingMessage.from(error)
        #expect(message == UserFacingMessage.sessionExpired)
    }
    
    @Test func badDataShowsBadDataMessage() {
        let error = NetworkError.decodingFailed(underlying: URLError(.cannotParseResponse))
        let message = UserFacingMessage.from(error)
        #expect( message == UserFacingMessage.badData)
    }
    
    @Test func otherErrorShowsGeneralMessage() {
        let error  = NetworkError.badResponse(statusCode: 500)
        let message = UserFacingMessage.from(error)
        #expect(message == UserFacingMessage.generalError)
    }
    
//    @Test
//    func noConnectionShowsOfflineMessage() {
//        let error = NetworkError.noConnection
//        let message = UserFacingMessage.from(error)
//        #expect(message == UserFacingMessage.offline)
//    }
}
