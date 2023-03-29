//
//  GenericResult.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    let error: NetworkError?
    let status: Int
    let result: T?
    
    enum CodingKeys: String, CodingKey {
        case error
        case status
        case result
    }
}

struct NetworkError: Codable {
    let code: Int
    let message: Int
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
    }
}
