//
//  LoadState.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/17/26.
//


enum LoadState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case failed(message: String)
}
