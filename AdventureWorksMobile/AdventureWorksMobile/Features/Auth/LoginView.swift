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
    enum Action {case usernameField, passwordField}
    @FocusState private var focusedField: Action?
    
    var body: some View {
 
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
 
                Text("Sign in")
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
 
                if let reason = authStatus.signOutReason {
                    Text(reason)
                        .foregroundStyle(.primary)
                }
 
                Text("Username")
                    .accessibilityHidden(true)
                TextField("Username", text: $viewModel.credentials.username)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.username)
                    .focused($focusedField, equals: .usernameField)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .passwordField }
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityLabel("Username")
                    .accessibilityIdentifier("usernamefield")
 
                Text("Password")
                    .accessibilityHidden(true)
                SecureField("Password", text: $viewModel.credentials.password)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.password)
                    .focused($focusedField, equals: .passwordField)
                    .submitLabel(.go)
                    .onSubmit {
                        if !viewModel.loginDisabled {
                            Task { await viewModel.login(session: authStatus) }
                        }
                    }
                    .accessibilityLabel("Password")
                    .accessibilityIdentifier("passwordfield")
 
                
                if !viewModel.errorMessage.isEmpty {
                    Label {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.primary)
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Error: \(viewModel.errorMessage)")
                }
 
                Button {
                    Task { await viewModel.login(session: authStatus) }
                } label: {
                    Group {
                        if viewModel.isBusy {
                            HStack(spacing: 8) {
                                Text("Signing in…")
                            }
                        } else {
                            Text("Sign in")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.loginDisabled)
                .accessibilityIdentifier("loginButton")
            }
            .padding(20)
            .disabled(viewModel.isBusy)
        }
        .scrollBounceBehavior(.basedOnSize)
        .onChange(of: viewModel.errorMessage) { _, newValue in
            guard !newValue.isEmpty else { return }
            AccessibilityNotification.Announcement("Error: \(newValue)").post()
        }
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
