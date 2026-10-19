//
//  UserFacingMessage.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/10/26.
//

import Foundation
enum UserFacingMessage{
    // MARK: error messages
    static  let invalidCredentials = "Incorrect username or password. Please try again."
    static let sessionExpired = "Your session expired. Please sign in again."
    static let signInRequired = "Please sign in to continue."
    static let offline = "You're offline. Check your connection and try again."
    static let timedOut = "The server took too long to respond. Please try again."
    static let badData = "Something went wrong reading the data. Please try again later."
    static let generalError = "Something went wrong. Please try again."
    
    
    static func from(_ error:Error) -> String {
        switch error {
        case let urlError as URLError where urlError.code == .notConnectedToInternet:
            return offline
        case let urlError as URLError where urlError.code == .timedOut:
            return timedOut
        case NetworkError.unauthorized:
            return sessionExpired
        case NetworkError.missingAuthToken:
            return signInRequired
        case NetworkError.decodingFailed:
            return badData
        default:
            return generalError
            
        }
    }
}
