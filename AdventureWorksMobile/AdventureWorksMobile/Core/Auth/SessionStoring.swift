//
//  SessionStoring.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/9/26.
//

protocol SessionStoring {
    func saveSession(accessToken: String, refreshToken: String)
    
    func clearSession(reason: String?)
    
    
}
