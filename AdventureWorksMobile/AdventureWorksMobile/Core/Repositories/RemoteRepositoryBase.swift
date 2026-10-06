//
//  RemoteRepositoryBase.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 9/14/26.
//

import Foundation

class RemoteRepositoryBase<Item: Codable> {
    
    private var authStatus: AuthStatus
    
    init(authStatus: AuthStatus) {
        self.authStatus = authStatus
    }
    
    // MARK: - fetch all method
    
    func fetchAll(_ urlString: String) async throws -> [Item] {
        
        let request = try createRequest(urlString)
        
        let data = try await executeRequest(request)
        
        // JSONDecoder is an object that decodes instances of a data type from
        // JSON objects
        // decode returns a value of the type specified in the first parameter
        // this will also ignore parameters in the API that we aren't using
        do {
            let decoder = JSONDecoder()
            // fee_fi_fo_fum converts to: feeFiFoFum
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([Item].self, from: data)
        }
        catch {
            throw NetworkError.decodingFailed(underlying: error)
        }
        
    }
    
    // MARK: - fetch one method
    
    func fetchOne(_ urlString: String) async throws -> Item {
        
        let request = try createRequest(urlString)
        
        let data = try await executeRequest(request)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            // in swift, Item.self is a reference to the data type Item
            return try decoder.decode(Item.self, from: data)
        }
        catch {
            throw NetworkError.decodingFailed(underlying: error)
        }
        
    }
    
    // MARK: - post method
    
    func post(_ urlString: String, send item: Item) async throws -> Item {
        
        // we use var as URLRequest is a struct (value type reference)
        // and we need to set the httpMethod and  header value
        var request = try createRequest(urlString)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // ultimately we will add authorization to this request
        
        do {
            request.httpBody = try JSONEncoder().encode(item)
        }
        catch {
            throw NetworkError.encodingFailed(underlying: error)
        }
        
        let data = try await executeRequest(request)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Item.self, from: data)
        }
        catch {
            throw NetworkError.decodingFailed(underlying: error)
        }
        
    }
    
    // MARK: - put method
    
    func put(_ urlString: String, send item: Item) async throws {
        
        var request = try createRequest(urlString)

        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // ultimately we will add authorization to this request
        
        do {
            request.httpBody = try JSONEncoder().encode(item)
        }
        catch {
            throw NetworkError.encodingFailed(underlying: error)
        }
        
        let _ = try await executeRequest(request)
        
    }
    
    // MARK: - delete method
    
    func del(_ urlString: String) async throws {
        
        var request = try createRequest(urlString)

        request.httpMethod = "DELETE"
        
        let _ = try await executeRequest(request)
        
    }
    
    // MARK: - Private utility methods
    
    private func createRequest(_ urlString: String) throws -> URLRequest {
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        guard let auth = authStatus.authToken, !auth.isEmpty else {
            throw NetworkError.missingAuthToken
        }
        request.setValue("Bearer \(auth)", forHTTPHeaderField: "Authorization")
        
        return request
        
    }
    
    private func executeRequest(_ request: URLRequest, isRetry: Bool = false) async throws -> Data {
        
        // URLSession.shared gets us to the singleton instance
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.badResponse(statusCode: -1)
        }
        
        guard (200...299).contains(http.statusCode) else {
            if http.statusCode == 401 {
                
                guard !isRetry,
                      let refresh = authStatus.refreshToken,
                        !refresh.isEmpty,
                      let auth = authStatus.authToken,
                        !auth.isEmpty else {
                    throw NetworkError.unauthorized
                }
                
                // try to refresh the auth token
                let refreshResult = try await AuthService.shared.refreshToken(authToken: auth, refreshToken: refresh)
                
                guard refreshResult.success else {
                    throw NetworkError.unauthorized
                }
                
                authStatus.updateLoginStatus(success: refreshResult.success,
                                             authToken: refreshResult.accessToken,
                                             refreshToken: refreshResult.refreshToken)
                
                // create a copy of the original request, as it is a let constant
                var newRequest = request
                newRequest.setValue("Baerer \(authStatus.authToken!)", forHTTPHeaderField: "Authorization")
                
                return try await executeRequest(newRequest, isRetry: true)
                
            }
            throw NetworkError.badResponse(statusCode: http.statusCode)
        }
        
        return data
        
    }
    
}
