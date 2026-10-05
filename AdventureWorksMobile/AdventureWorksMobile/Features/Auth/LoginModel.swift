//
//  LoginModel.swift
//  SwiftUIDemo
//
//  Created by Miles Eidson on 9/15/26.
//

struct LoginModel: Codable {
    
    var username: String = ""
    var password: String = ""
    
    enum CodingKeys: String, CodingKey {
        case username = "loginId"
        case password
    }
    
}
