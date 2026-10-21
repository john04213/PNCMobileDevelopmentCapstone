//
//  LoadState.swift
//  AdventureWorksMobile
//
//  Created by user304506 on 10/14/26.
//

import Foundation

enum LoadingState {
    case loading
    case success
    case empty
    case failure(String)
    case refreshing
    case refreshFailure(String)
}
