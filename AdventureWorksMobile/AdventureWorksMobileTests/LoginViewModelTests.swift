//
//  LoginViewModelTests.swift
//  AdventureWorksMobileTests
//
//  Created by John Hernandez on 10/11/26.
//

import Foundation
import Testing
@testable import AdventureWorksMobile

@MainActor
struct LoginViewModelTests {
    @Test func successSavesToken() async {
        // Arrange
        let auth = FakeAuthService()
        auth.result = LoginResponse(success: true, userName: "ken0",
                                    accessToken: "a", refreshToken: "r")
        
        let store = FakeSessionStore()
        let vm = LoginView.ViewModel(authService: auth)
        
        // act
        await vm.login(session: store)
        
        // Assert
        #expect(store.savedAccessToken == "a")
        #expect(vm.errorMessage.isEmpty)
        #expect(vm.isBusy == false)
    }
    
    @Test func wrongPasswordShowsFriendlyMessage() async {
        let auth = FakeAuthService()
        auth.result = LoginResponse(success: false, userName: "ken0")
        
        let store = FakeSessionStore()
        let vm = LoginView.ViewModel(authService: auth)
        
        await vm.login(session: store)
        
        #expect(vm.errorMessage == UserFacingMessage.invalidCredentials)
        #expect(store.savedAccessToken == nil)
    }
    
    @Test func offlineShowsFriendlyMessage() async {
        // Arrange
        let auth = FakeAuthService()
        auth.errorToThrow = URLError(.notConnectedToInternet)
        let store = FakeSessionStore()
        let vm = LoginView.ViewModel(authService: auth)
        
        
        
        // Act
        await vm.login(session: store)
       
        // assert
        #expect(!vm.errorMessage.contains("URLError"))
        #expect(vm.errorMessage == UserFacingMessage.from(URLError(.notConnectedToInternet)))
        
    }
    
    @Test func retryClearsOldError() async {
        let  auth = FakeAuthService()
         auth.errorToThrow = URLError(.notConnectedToInternet)
        let store = FakeSessionStore()
        let vm = LoginView.ViewModel(authService: auth)
        
        await vm.login(session: store)
        
        #expect(!vm.errorMessage.isEmpty)
        
        auth.errorToThrow = nil
        auth.result  = LoginResponse(success: true, userName: "Ken0", accessToken: "a", refreshToken: "r")
        
        await vm.login(session: store)
        #expect(vm.errorMessage.isEmpty)
        #expect(store.savedAccessToken == "a")
        
    }
}
