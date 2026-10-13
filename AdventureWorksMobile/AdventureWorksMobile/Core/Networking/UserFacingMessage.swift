//
//  UserFacingMessage.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/10/26.
//

import Foundation
enum UserFacingMessage{
    static  let invalidCredentials = "Incorrect username or password. Please try again."
    
    static let sessionExpired = "Your session expired. Please sign in again."
    
    static func from(_ error:Error) -> String {
        switch error {
        case let urlError as URLError where urlError.code == .notConnectedToInternet:
            return "You're offline. Check your connection and try again."
        case let urlError as URLError where urlError.code == .timedOut:
            return "The server took too long to respond. Please try again."
        case NetworkError.unauthorized, NetworkError.missingAuthToken:
            return sessionExpired
        case NetworkError.decodingFailed:
            return "Something went wrong reading the data. Please try again later."
        default:
            return "Something went wrong. Please try again"
            
        }
    }
}
