//
//  LoginView.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 9/15/26.
//

import SwiftUI

struct LoginView: View {
    
    @State private var viewModel = ViewModel()
    // This will look at the environment and find
    // anything that is this data type and give it
    // to us. It's also specifically designed for
    // objects that maintain some state
    @EnvironmentObject var authStatus: AuthStatus
    
    var body: some View {
        
        VStack {
            
            Text("Login").font(Font.largeTitle.bold())
            if let reason = authStatus.signOutReason{
                Text(reason)
                    .foregroundColor(.secondary)
            }
            
            TextField("Username", text: $viewModel.credentials.username)
                .accessibilityIdentifier("usernamefield")
            SecureField("Password", text: $viewModel.credentials.password)
                .accessibilityIdentifier("passwordfield")
            
            if viewModel.isBusy {
                ProgressView()
            }
            
            Button("Log in") {
                Task {
                    await viewModel.login(session: authStatus)
                    }
                }
            
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.loginDisabled)
            .accessibilityIdentifier("loginButton")
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(Color.red)
            }
            
            Spacer()
            
        }
        .padding(20)
        .autocapitalization(.none)
        .disabled(viewModel.isBusy)
        
    }
    
}

extension LoginView {
    
    @Observable
    class ViewModel {
        
        var credentials = LoginModel()
        var isBusy = false
        
        var loginDisabled: Bool {
            credentials.username.isEmpty || credentials.password.isEmpty || isBusy
        }
        
        var errorMessage: String = ""
        
        private let authService: any AuthServiceProtocol
        
        init(
            authService: any AuthServiceProtocol =  AuthService.shared
        ) {
            self.authService = authService
        }
        
        
        func login(session: any SessionStoring) async {
            guard !isBusy else { return }
            
            isBusy = true
            defer { isBusy = false }
            errorMessage = ""
            
            do {
                let response = try await authService.login(credentials: credentials)
                
                if response.success,
                    let access = response.accessToken,
                    let refresh = response.refreshToken {
                        session.saveSession(accessToken: access, refreshToken: refresh)
                    }
                 else {
                    errorMessage = UserFacingMessage.invalidCredentials
                    credentials.password = ""
                }
            } catch {
                errorMessage = UserFacingMessage.from(error)
            }
        }
        
    }
    

}

#Preview {
    LoginView().environmentObject(AuthStatus())
}
